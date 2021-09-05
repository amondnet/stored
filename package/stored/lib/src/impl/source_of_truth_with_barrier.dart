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
    _logger.info('reader version : $readerVersion');

    try {
      await lock;

      yield* barrier.switchMap((value) {
        _logger.info('value : $value}');
        final messageArriveAfterMe = readerVersion < value.version;
        _logger.info('messageArriveAfterMe : $messageArriveAfterMe');

        var writeError;
        if (messageArriveAfterMe && value is Open) {
          writeError = value.writeError;
        }

        Stream<StoreResponse<Output?>> readStream;

        if (value is Open) {
          print('value is open');
          var index = 0;
          readStream = _delegate.reader(key).map((output) {
            print('index is $index');

            if (index++ == 0 && messageArriveAfterMe) {
              var firstMsgOrigin;
              if (writeError == null) {
                print('write error is null');
                firstMsgOrigin = ResponseOrigin.Fetcher;
              } else {
                firstMsgOrigin = ResponseOrigin.SourceOfTruth;
              }
              return StoreResponse.data<Output?>(
                  origin: firstMsgOrigin, value: output);
            } else {
              print('else');
              return StoreResponse.data<Output?>(
                  origin: ResponseOrigin.SourceOfTruth, value: output);
            }
          }).handleError((error, stackTrace) => ExceptionStoreResponse(
              ReadException(key: key, cause: error),
              ResponseOrigin.SourceOfTruth));
        } else {
          // blocked
          _logger.info('blocked');
          readStream = Stream.empty();
        }

        // TODO(amond): if we have a pending error, make sure to dispatch it first.
        /*
         if (writeError != null) {
                                        emit(
                                            StoreResponse.Error.Exception(
                                                origin = ResponseOrigin.SourceOfTruth,
                                                error = writeError
                                            )
                                        )
                                    }
         */
        return readStream.onStart((sink) {
          if (writeError != null) {
            sink.add(StoreResponse.error(
                error: writeError, origin: ResponseOrigin.SourceOfTruth));
          }
          return Future.value(null);
        });
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
