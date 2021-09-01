import 'package:meta/meta.dart';
import 'package:quiver/cache.dart';
import 'package:stored/src/fetcher.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';
import 'package:stored/src/memory_policy.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store.dart';

@internal
class RealStore<Key, Input, Output> implements Store<Key, Output> {
  final MemoryPolicy<Key, Output>? _memoryPolicy;
  final SourceOfTruthWithBarrier<Key, Input, Output>? _sourceOfTruth;

  final Cache? _memCache;

  final FetcherController

  RealStore(
      {required Fetcher<Key, Input> fetcher,
      SourceOfTruth<Key, Input, Output>? sourceOfTruth,
      MemoryPolicy<Key, Output>? memoryPolicy})
      : _memoryPolicy = memoryPolicy,
        _sourceOfTruth = sourceOfTruth != null
            ? SourceOfTruthWithBarrier(sourceOfTruth)
            : null,
        // TODO(amond): use cache implmentation
        _memCache = MapCache.lru();

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
  Stream<Output> stream() {
    // TODO: implement stream
    throw UnimplementedError();
  }
}
