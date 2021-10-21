import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stored/src/impl/ref_counted_resource.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store_response.dart';
import 'real_store.dart';
import 'operators/stream_merge.dart';

/// Wraps a [SourceOfTruth] and blocks reads while a write is in progress.
///
/// Used in the [RealStore] implementation to avoid
/// dispatching values to downstream while a write is in progress.
@internal
class SourceOfTruthWithBarrier<Key, Input, Output> {
  final SourceOfTruth<Key, Input, Output> _delegate;

  final _logger = Logger('SourceOfTruthWithBarrier');

  /// Each key has a barrier so that we can block reads while writing.
  final _barriers = RefCountedResource<Key, BehaviorSubject<BarrierMsg>>(
    (_) => BehaviorSubject.seeded(Open.INITIAL),
  );

  /// Each message gets dispatched with a version. This ensures we won't accidentally turn on the
  /// reader flow for a new reader that happens to have arrived while a write is in progress since
  /// that write should be considered as a disk read for that flow, not fetcher.
  int _versionCounter = 0;

  SourceOfTruthWithBarrier(this._delegate);

  Stream<StoreResponse<Output?>> reader(Key key, Future lock) async* {
    final barrier = await _barriers.acquire(key);
    final readerVersion = ++_versionCounter;
    _logger.finest('reader version : $readerVersion');

    try {
      await lock;

      // switchMap is called flatMapLatest
      yield* barrier.switchMap((value) {
        _logger.finest('value : $value');
        final messageArriveAfterMe = readerVersion < value.version;
        _logger.finest('messageArriveAfterMe : $messageArriveAfterMe');

        var writeError;
        if (messageArriveAfterMe && value is Open) {
          writeError = value.writeError;
        } else {
          writeError = null;
        }

        Stream<StoreResponse<Output?>> readStream;

        if (value is Open) {
          var index = 0;

          final _transformer =
              StreamTransformer<Output?, StoreResponse<Output?>>.fromHandlers(
                  handleData: (data, sink) {
            _logger.finest('index is $index');

            if (index == 0 && messageArriveAfterMe) {
              var firstMsgOrigin;
              if (writeError == null) {
                _logger.finest('firstMsgOrigin : Fetcher');
                // restarted barrier without an error means write succeeded
                firstMsgOrigin = ResponseOrigin.Fetcher;
              } else {
                // when a write fails, we still get a new reader because
                // we've disabled the previous reader before starting the
                // write operation. But since write has failed, we should
                // use the SourceOfTruth as the origin
                _logger.finest('firstMsgOrigin : SourceOfTruth');
                firstMsgOrigin = ResponseOrigin.SourceOfTruth;
              }
              _logger.finest('return first msg');
              index++;
              sink.add(StoreResponse.data(origin: firstMsgOrigin, value: data));
            } else {
              _logger.finest('return from source of truth');
              index++;
              sink.add(StoreResponse.data(
                  origin: ResponseOrigin.SourceOfTruth, value: data));
            }
          }, handleError: (error, stackTrace, sink) {
            _logger.finest('handle error for $error', error);
            sink.add(ExceptionStoreResponse<Output?>(
                ReadException(key: key, cause: error),
                ResponseOrigin.SourceOfTruth));
          });

          readStream = _delegate.reader(key).transform(_transformer);
        } else {
          // blocked
          _logger.info('blocked');
          readStream = Stream.empty();
        }

        if (writeError != null) {
          _logger.finest(
              'if we have a pending error, make sure to dispatch it first.');
          // if we have a pending error, make sure to dispatch it first.
          return ConcatStream<StoreResponse<Output?>>([
            Stream.value(StoreResponse.error(
                error: writeError, origin: ResponseOrigin.SourceOfTruth)),
            readStream
          ]);
        } else {
          _logger.finest('return read stream');
          return readStream;
        }
      });
    } finally {
      // we are using a finally here instead of onCompletion as there might be a
      // possibility where flow gets cancelled right before `emitAll`.
      _logger.finest('finally release');
      await _barriers.release(key, barrier);
    }
  }

  Future<void> write(Key key, Input value) async {
    _logger.finest('write');

    final barrier = await _barriers.acquire(key);

    try {
      barrier.add(BarrierMsg.blocked(++_versionCounter));
      _logger.finest('_versionCounter : $_versionCounter');

      var writeError;
      try {
        await _delegate.write(key, value);
        _logger.finest('written');
        writeError = null;
      } catch (e) {
        writeError = e;
      }

      barrier.add(BarrierMsg.open(++_versionCounter,
          writeError: writeError != null
              ? WriteException(cause: writeError, key: key, value: value)
              : null));
      _logger.finest('_versionCounter : $_versionCounter');

      //if (writeError is CancellationException) {
      //  // only throw if it failed because of cancelation.
      //  // otherwise, we take care of letting downstream know that there was a write error
      //  throw writeError
      // }
    } finally {
      await _barriers.release(key, barrier);
    }
  }

  Future<void> delete(Key key) => _delegate.delete(key);

  Future<void> deleteAll() => _delegate.deleteAll();

  // visible for testing
  @visibleForTesting
  Future<int> get barrierCount => _barriers.size;
}

@sealed
@internal
class BarrierMsg {
  final int version;

  BarrierMsg(this.version);

  static BarrierMsg open(int version, {dynamic writeError}) =>
      Open(version, writeError: writeError);

  static BarrierMsg blocked(int version) => Blocked(version);
}

class Blocked extends BarrierMsg {
  Blocked(int version) : super(version);
}

class Open extends BarrierMsg {
  final dynamic writeError;

  Open(int version, {this.writeError}) : super(version);

  static final INITIAL = Open(_INITIAL_VERSION);
}

const _INITIAL_VERSION = -1;
