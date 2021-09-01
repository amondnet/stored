import 'package:stored/src/fetcher.dart';
import 'package:stored/src/memory_policy.dart';
import 'package:stored/src/source_of_truth.dart';

import 'impl/real_store.dart';
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

  /// Creates a new [StoreBuilder] from a [Fetcher] and a [SourceOfTruth].
  ///
  /// [fetcher] a function for fetching a flow of network records.
  /// [sourceOfTruth] a [SourceOfTruth] for the store.
  static StoreBuilder<Key, Output> from<Key, Input, Output>(
      Fetcher<Key, Output> fetcher,
      {SourceOfTruth<Key, Input, Output>? sourceOfTruth}) {
    return _RealStoreBuilder(fetcher, sourceOfTruth: sourceOfTruth);
  }
}

class _RealStoreBuilder<Key, Input, Output> extends StoreBuilder<Key, Output> {
  final Fetcher<Key, Input> _fetcher;
  final SourceOfTruth<Key, Input, Output>? sourceOfTruth;

  MemoryPolicy<Key, Output>? _cachePolicy;

  _RealStoreBuilder(this._fetcher, {this.sourceOfTruth});

  @override
  Store<Key, Output> build() {
    return RealStore<Key, Input, Output>(
        fetcher: _fetcher,
        memoryPolicy: _cachePolicy,
        sourceOfTruth: sourceOfTruth);
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
