import 'package:meta/meta.dart';

import 'store_response.dart';
import 'store_request.dart';

/// A Store is responsible for managing a particular data request.
///
/// When you create an implementation of a Store, you provide it with a Fetcher, a function that defines how data will be fetched over network.
///
/// You can also define how your Store will cache data in-memory and on-disk. See [StoreBuilder] for full configuration
///
/// Example usage:
///
/// val store = StoreBuilder
///  .fromNonFlow<Pair<String, RedditConfig>, List<Post>> { (query, config) ->
///    provideRetrofit().fetchData(query, config.limit).data.children.map(::toPosts)
///   }
///  .persister(reader = { (query, _) -> db.postDao().loadData(query) },
///             writer = { (query, _), posts -> db.dataDAO().insertData(query, posts) },
///             delete = { (query, _) -> db.dataDAO().clearData(query) },
///             deleteAll = db.postDao()::clearAllFeeds)
///  .build()
///
///  // single shot response
///  viewModelScope.launch {
///      val data = store.fresh(key)
///  }
///
///  // get cached data and collect future emissions as well
///  viewModelScope.launch {
///    val data = store.cached(key, refresh=true)
///                    .collect{data.value=it }
///  }
///
abstract class Store<K, V> {
  /// Return a flow for the given key
  ///
  /// [request] - see [StoreRequest] for configurations
  Stream<StoreResponse<V>> stream(StoreRequest<K> request);

  Future<void> clear();

  @experimental
  Future<void> clearAll();
}

extension StoreX<Key, Output> on Store<Key, Output> {
  /// Helper factory that will return data for [key] if it is cached otherwise will return
  /// fresh/network data (updating your caches)
  Future<Output> get(Key key) => stream(StoreRequest.cached(key, false))
      .firstWhere((event) =>
          !(event is LoadingStoreResponse || event is NoNewDataStoreResponse))
      .then((value) => value.requireData());

  /// Helper factory that will return fresh data for [key] while updating your caches
  ///
  /// Note: If the [Fetcher] does not return any data (i.e the returned
  /// [kotlinx.coroutines.Flow], when collected, is empty). Then store will fall back to local
  /// data **even** if you explicitly requested fresh data.
  /// See https://github.com/dropbox/Store/pull/194 for context
  ///
  Future<Output> fresh(Key key) => stream(StoreRequest.fresh(key))
      .firstWhere((event) =>
          !(event is LoadingStoreResponse || event is NoNewDataStoreResponse))
      .then((value) => value.requireData());
}
