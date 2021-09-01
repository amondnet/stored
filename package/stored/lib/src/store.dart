import 'package:meta/meta.dart';

abstract class Store<K, V> {
  /// Return a flow for the given key
  ///
  /// request - see [StoreRequest] for configurations
  Stream<V> stream();

  Future<void> clear();

  @experimental
  Future<void> clearAll();
}
