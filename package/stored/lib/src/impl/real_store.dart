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

@internal
class RealStore<Key, Input, Output> implements Store<Key, Output> {
  final MemoryPolicy<Key, Output>? _memoryPolicy;
  final SourceOfTruthWithBarrier<Key, Input, Output>? _sourceOfTruth;

  final Cache? _memCache;

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
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  Stream<StoreResponse<Output>> stream(StoreRequest<Key> request) async* {
    var cachedToEmit;
    if (request.shouldSkipCache(CacheType.MEMORY)) {
      cachedToEmit = null;
    } else {
      await _memCache?.get(request.key);
    }

    if (cachedToEmit != null) {
      // if we read a value from cache, dispatch it first
      yield StoreResponse.data(
          value: cachedToEmit, origin: ResponseOrigin.Cache);
    }
    var stream;
    if (_sourceOfTruth == null) {
      // piggypack only if not specified fresh data AND we emitted a value from the cache
      final piggybackOnly = !request.refresh && cachedToEmit != null;

      createdNetworkStream(request);
    }
  }

  Stream<StoreResponse<Input>> createdNetworkStream(StoreRequest<Key> request,
      {Future? networkLock, bool piggybackOnly = false}) async* {
    // wait until disk gives us to go
    if (networkLock != null) {
      await networkLock;
    }
    if (!piggybackOnly) {
      yield StoreResponse.loading(origin: ResponseOrigin.Fetcher);
    }
    yield* _fetcherController.getFetcher(request.key,
        piggybackOnly: piggybackOnly);
  }
}
