import 'package:meta/meta.dart';

import 'store_response.dart';
import 'store_request.dart';

abstract class Store<K, V> {
  /// Return a flow for the given key
  ///
  /// [request] - see [StoreRequest] for configurations
  Stream<StoreResponse<V>> stream(StoreRequest<K> request);

  Future<void> clear();

  @experimental
  Future<void> clearAll();
}
