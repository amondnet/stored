import 'package:stored/src/store.dart';
import 'package:stored/src/store_request.dart';
import 'package:stored/src/store_response.dart';

extension TestStoreExt<Key, Output> on Store<Key, Output> {
  Future<StoreResponse<Output>> getData(Key key) =>
      stream(StoreRequest.cached(key, false))
          .where((element) => !(element is LoadingStoreResponse))
          .first
          .then((value) => StoreResponse.data<Output>(
              origin: value.origin, value: value.requireData()));
}
