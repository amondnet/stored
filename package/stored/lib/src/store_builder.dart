import 'package:stored/src/fetcher.dart';
import 'package:stored/src/memory_policy.dart';
import 'package:stored/src/source_of_truth.dart';

import 'store.dart';

/// Main entry point for creating a [Store].
abstract class StoreBuilder<Key, Output> {
  Store<Key, Output> build();

  /// controls eviction policy for a store cache, use [MemoryPolicyBuilder] to configure a TTL
  ///  or size based eviction
  ///  Example: MemoryPolicy.builder().setExpireAfterWrite(10.seconds).build()
  StoreBuilder<Key, Output> cachePolicy(
      MemoryPolicy<Key, Output>? memoryPolicy);

  /// by default a Store caches in memory with a default policy of max items = 100
  StoreBuilder<Key, Output> disableCache();

  static StoreBuilder<Key, Output> from() {}
}

class _RealStoreBuilder<Key, Input, Output> extends StoreBuilder<Key, Output> {
  final Fetcher<Key, Input> _fetcher;
  final SourceOfTruth<Key, Input, Output>? sourceOfTruth;

  MemoryPolicy<Key, Output>? _cachePolicy;

  _RealStoreBuilder(this._fetcher, {this.sourceOfTruth});

  @override
  Store<Key, Input> build() {
    return RealStore()
  }

  @override
  StoreBuilder<Key, Output> cachePolicy(
      MemoryPolicy<Key, Output>? memoryPolicy) {
    _cachePolicy = memoryPolicy;
    return this;
  }

  @override
  StoreBuilder<Key, Output> disableCache() {
    _cachePolicy = null;
    return this;
  }
}
