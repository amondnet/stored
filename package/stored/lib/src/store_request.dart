import 'package:meta/meta.dart';

/// data class to represent a single store request
/// [key] a unique identifier for your data
/// [skippedCaches] List of cache types that should be skipped when retuning the response see [CacheType]
/// [refresh] If set to true  [Store] will always get fresh value from fetcher while also
///  starting the stream from the local [com.dropbox.android.external.store4.impl.SourceOfTruth] and memory cache
///
class StoreRequest<Key> {
  final Key key;

  final int _skippedCaches;

  final bool refresh;

  StoreRequest._(this.key, this._skippedCaches, {this.refresh = false});

  @internal
  bool shouldSkipCache(CacheType cacheType) {
    return _skippedCaches & cacheType.flag != 0;
  }

  static final allCaches = CacheType.values
      .fold(0, (int previousValue, element) => previousValue | element.flag);

  /// Create a Store Request which will skip all caches and hit your fetcher
  /// (filling your caches).
  ///
  /// Note: If the [Fetcher] does not return any data (i.e the returned
  /// [kotlinx.coroutines.Flow], when collected, is empty). Then store will fall back to local
  /// data **even** if you explicitly requested fresh data.
  /// See https://github.com/dropbox/Store/pull/194 for context.
  static StoreRequest<K> fresh<K>(K key) {
    return StoreRequest._(key, allCaches, refresh: true);
  }

  /// Create a Store Request which will return data from memory/disk caches
  /// [refresh] if true then return fetcher (new) data as well (updating your caches)
  static StoreRequest<K> cached<K>(K key, bool refresh) {
    return StoreRequest._(key, 0, refresh: refresh);
  }

  static StoreRequest<K> skipMemory<K>(K key, bool refresh) {
    return StoreRequest._(key, CacheType.MEMORY.flag, refresh: refresh);
  }
}

enum CacheType { MEMORY, DISK }

extension on CacheType {
  int get flag {
    switch (this) {
      case CacheType.MEMORY:
        return int.parse('0b01', radix: 2);
      case CacheType.DISK:
        // TODO: Handle this case.
        return int.parse('0b10', radix: 2);
    }
  }
}
