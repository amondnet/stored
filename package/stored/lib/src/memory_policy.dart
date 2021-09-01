import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiver/check.dart';

import 'store.dart';

abstract class Weigher<K, V> {
  /// Returns the weight of a cache entry. There is no unit for entry weights; rather they are simply
  /// relative to each other.
  ///
  /// returns the weight of the entry; must be non-negative
  int weight(K key, V value);
}

class _OneWeigher<K, V> extends Weigher<K, V> {
  @override
  int weight(key, value) => 1;

  _OneWeigher._();
}

/// MemoryPolicy holds all required info to create MemoryCache
///
///
/// This class is used, in order to define the appropriate parameters for the Memory [com.dropbox.android.external.cache3.Cache]
/// to be built.
///
///
/// MemoryPolicy is used by a [Store]
/// and defines the in-memory cache behavior.
class MemoryPolicy<Key, Value> {
  static final Duration DEFAULT_DURATION_POLICY =
      Duration(seconds: double.maxFinite.toInt());
  static const int DEFAULT_SIZE_POLICY = -1;

  final Duration expireAfterWrite;
  final Duration expireAfterAccess;
  final int maxSize;
  final int maxWeight;
  final Weigher<Key, Value> weigher;

  MemoryPolicy._(this.expireAfterWrite, this.expireAfterAccess, this.maxSize,
      this.maxWeight, this.weigher);

  static MemoryPolicyBuilder<Key, Value> builder<Key, Value>() =>
      MemoryPolicyBuilder<Key, Value>();
}

class MemoryPolicyBuilder<Key, Value> {
  var _expireAfterWrite = MemoryPolicy.DEFAULT_DURATION_POLICY;
  var _expireAfterAccess = MemoryPolicy.DEFAULT_DURATION_POLICY;
  var _maxSize = MemoryPolicy.DEFAULT_SIZE_POLICY;
  var _maxWeight = MemoryPolicy.DEFAULT_SIZE_POLICY;
  Weigher<Key, Value> _weigher = _OneWeigher._();

  set expireAfterWrite(value) {
    checkState(_expireAfterAccess == MemoryPolicy.DEFAULT_DURATION_POLICY,
        message:
            'Cannot set expireAfterWrite with expireAfterAccess already set');
    _expireAfterWrite = value;
  }

  set expireAfterAccess(value) {
    checkState(_expireAfterWrite == MemoryPolicy.DEFAULT_DURATION_POLICY,
        message:
            'Cannot set expireAfterAccess with expireAfterWrite already set');
    _expireAfterAccess = value;
  }

  ///  Sets the maximum number of items ([maxSize]) kept in the cache.
  ///
  ///  When [maxSize] is 0, entries will be discarded immediately and no values will be cached.
  ///
  ///  If not set, cache size will be unlimited.
  set maxSize(int maxSize) {
    checkState(
        _maxWeight == MemoryPolicy.DEFAULT_SIZE_POLICY &&
            _weigher is _OneWeigher,
        message: 'Cannot setMaxSize when maxWeight or weigher are already set');
    checkArgument(maxSize >= 0, message: 'maxSize cannot be negative');

    _maxSize = maxSize;
  }

  void setWeigherAndMaxWeight(Weigher<Key, Value> weigher, int maxWeight) {
    checkState(_maxSize == MemoryPolicy.DEFAULT_SIZE_POLICY,
        message: 'Cannot setWeigherAndMaxWeight when maxSize already set');

    checkArgument(maxWeight >= 0, message: 'maxWeight cannot be negative');
    _weigher = weigher;
    _maxWeight = maxWeight;
  }

  MemoryPolicy<Key, Value> build() => MemoryPolicy._(
      _expireAfterWrite, _expireAfterAccess, _maxSize, _maxWeight, _weigher);
}
