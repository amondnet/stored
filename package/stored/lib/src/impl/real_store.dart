import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:quiver/cache.dart';
import 'package:stored/src/fetcher.dart';
import 'package:stored/src/impl/fetcher_controller.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';
import 'package:stored/src/memory_policy.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store.dart';
import 'package:stored/src/store_request.dart';
import 'package:stored/src/store_response.dart';
import 'operators/stream_merge.dart';
import 'package:stream_transform/stream_transform.dart';

@internal
class RealStore<Key, Input, Output> implements Store<Key, Output> {
  final MemoryPolicy<Key, Output>? _memoryPolicy;
  final SourceOfTruthWithBarrier<Key, Input, Output>? _sourceOfTruth;

  final Cache? _memCache;
  final _logger = Logger('RealStore');

  /// Fetcher controller maintains 1 and only 1 `Multicaster` for a given key to ensure network
  /// requests are shared.
  late final FetcherController<Key, Input, Output> _fetcherController;

  RealStore(
      {required Fetcher<Key, Input> fetcher,
      SourceOfTruth<Key, Input, Output>? sourceOfTruth,
      MemoryPolicy<Key, Output>? memoryPolicy})
      : _memoryPolicy = memoryPolicy,
        _sourceOfTruth = sourceOfTruth != null
            ? SourceOfTruthWithBarrier(sourceOfTruth)
            : null,
        // TODO(amond): use cache implmentation
        _memCache = MapCache.lru() {
    _fetcherController = FetcherController<Key, Input, Output>(fetcher,
        sourceOfTruth: _sourceOfTruth);
  }

  @override
  Future<void> clear() {
    _logger.finest('clear');
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> clearAll() {
    _logger.finest('clearAll');

    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  Stream<StoreResponse<Output>> stream(StoreRequest<Key> request) async* {
    _logger.finest('stream { request : $request }');

    var cachedToEmit;
    if (request.shouldSkipCache(CacheType.MEMORY)) {
      _logger.finest('shouldSkipCache memory');
      cachedToEmit = null;
    } else {
      _logger.finest('get from memory');
      cachedToEmit = await _memCache?.get(request.key);
    }

    if (cachedToEmit != null) {
      _logger.finest('if we read a value from cache, dispatch it first');
      // if we read a value from cache, dispatch it first
      yield StoreResponse.data(
          value: cachedToEmit, origin: ResponseOrigin.Cache);
    }
    late Stream<StoreResponse<Output>> stream;
    if (_sourceOfTruth == null) {
      // piggypack only if not specified fresh data AND we emitted a value from the cache
      final piggybackOnly = !request.refresh && cachedToEmit != null;

      _logger.finest('when no source of truth Input == Output');
      stream = createdNetworkStream(request, piggybackOnly: piggybackOnly)
          as Stream<
              StoreResponse<Output>>; // when no source of truth Input == Output
    } else {
      stream = diskNetworkCombined(request, _sourceOfTruth!);
    }

    yield* stream.transform(StreamTransformer<StoreResponse<Output>,
        StoreResponse<Output>>.fromHandlers(handleData: (data, sink) async {
      // whenever a value is dispatched, save it to the memory cache
      if (data.origin != ResponseOrigin.Cache) {
        final dataOrNull = data.dataOrNull();
        if (dataOrNull != null) {
          await _memCache?.set(request.key, dataOrNull);
        }
      }
      sink.add(data);
      if (data is NoNewDataStoreResponse && cachedToEmit == null) {
        // In the special case where fetcher returned no new data we actually want to
        // serve cache data (even if the request specified skipping cache and/or SoT)
        //
        // For stream(Request.cached(key, refresh=true)) we will return:
        // Cache
        // Source of truth
        // Fetcher - > Loading
        // Fetcher - > NoNewData
        // (future Source of truth updates)
        //
        // For stream(Request.fresh(key)) we will return:
        // Fetcher - > Loading
        // Fetcher - > NoNewData
        // Cache
        // Source of truth
        // (future Source of truth updates)
        final v = await _memCache?.get(request.key);
        if (v != null) {
          sink.add(StoreResponse.data(origin: ResponseOrigin.Cache, value: v));
        }
      }
    }));
  }

  Stream<StoreResponse<Input>> createdNetworkStream(StoreRequest<Key> request,
      {Completer? networkLock, bool piggybackOnly = false}) async* {
    _logger.finest('createdNetworkStream');

    yield* _fetcherController
        .getFetcher(request.key, piggybackOnly: piggybackOnly)
        .onStart((s) async {
      if (networkLock != null) {
        _logger.finest('wait network lock');

        //_controller.add(StoreResponse.loading(origin: ResponseOrigin.Fetcher));
        // await networkLock.future;
      }
      if (!piggybackOnly) {
        s.add(StoreResponse.loading<Input>(origin: ResponseOrigin.Fetcher));
      }
    });
    ;
  }

  Stream<StoreResponse<Output>> diskNetworkCombined(
    StoreRequest<Key> request,
    SourceOfTruthWithBarrier<Key, Input, Output> sourceOfTruth,
  ) {
    _logger.finest('diskNetworkCombined');
    final diskLock = Completer<void>.sync();
    final networkLock = Completer<void>.sync();
    final networkStream =
        createdNetworkStream(request, networkLock: networkLock);
    final skipDiskCache = request.shouldSkipCache(CacheType.DISK);
    if (!skipDiskCache) {
      _logger.finest('diskLock.complete');
      if (!diskLock.isCompleted) {
        diskLock.complete();
      }
    }

    final diskStream =
        sourceOfTruth.reader(request.key, diskLock.future).onStart((sink) {
      // wait for disk to latch first to ensure it happens before network triggers.
      // after that, if we'll not read from disk, then allow network to continue
      if (skipDiskCache) {
        //if (!networkLock.isCompleted) {
        networkLock.complete();
        //}
      }
      return Future.value(null);
    });

    return networkStream.transform<StoreResponse<Output>>(
        StreamTransformer.fromHandlers(
            handleData: (StoreResponse<Input> data, sink) {
      if (data is DataStoreResponse || data is NoNewDataStoreResponse) {
        if (!diskLock.isCompleted) {
          diskLock.complete();
        }
      }
      if (data is! DataStoreResponse) {
        _logger.info('data :${data}');
        sink.add(data.swapType<Output>());
      }
    })).merge(diskStream
        .transform(StreamTransformer.fromHandlers(handleData: (diskData, sink) {
      if (diskData is DataStoreResponse) {
        final diskValue = (diskData as DataStoreResponse).value;
        if (diskValue != null) {
          sink.add(diskData as StoreResponse<Output>);
        }
        // If the disk value is null or refresh was requested then allow fetcher
        // to start emitting values.
        if (request.refresh || (diskData as DataStoreResponse).value == null) {
          if (!networkLock.isCompleted) {
            networkLock.complete();
          }
        }
      } else if (diskData is ErrorStoreResponse<Output>) {
        // disk sent an error, send it down as well
        sink.add(diskData);
        // If disk sent a read error, we should allow fetcher to start emitting
        // values since there is nothing to read from disk. If disk sent a write
        // error, we should NOT allow fetcher to start emitting values as we
        // should always wait for the read attempt.
        if (diskData is ErrorStoreResponse &&
            diskData.errorMessageOrNull() is ReadException) {
          if (!networkLock.isCompleted) {
            networkLock.complete();
          }
        }
        // for other errors, don't do anything, wait for the read attempt
      }
    })));

    /*
    return networkStream
        .eitherMerge(diskStream)
        .transform<StoreResponse<Output>>(
            StreamTransformer.fromHandlers(handleData: (either, sink) {
      if (either is Left) {
        final left =
            either as Left<StoreResponse<Input?>, StoreResponse<Output?>>;
        if (left.value is DataStoreResponse ||
            left.value is NoNewDataStoreResponse) {
          diskLock.complete();
        }
        if (left.value is! DataStoreResponse<Output>) {
          sink.add(left.value.swapType<Output>());
        }
      } else {
        // right, that is data from disk
        final right = either as Right;
        final diskData = right.value;
        if (diskData is DataStoreResponse) {
          final diskValue = diskData.value;
          if (diskValue != null) {
            sink.add(diskData as StoreResponse<Output>);
          }
          // If the disk value is null or refresh was requested then allow fetcher
          // to start emitting values.
          if (request.refresh || diskData.value == null) {
            networkLock.complete();
          }
        } else if (diskData is ErrorStoreResponse<Output>) {
          // disk sent an error, send it down as well
          sink.add(diskData);
          // If disk sent a read error, we should allow fetcher to start emitting
          // values since there is nothing to read from disk. If disk sent a write
          // error, we should NOT allow fetcher to start emitting values as we
          // should always wait for the read attempt.
          if (diskData is ErrorStoreResponse &&
              diskData.errorMessageOrNull() is ReadException) {
            networkLock.complete();
          }
          // for other errors, don't do anything, wait for the read attempt
        }
      }
    }));*/
  }
}
