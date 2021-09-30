import 'package:stored/src/store.dart';
import 'package:stored/src/store_request.dart';
import 'package:stored/src/store_response.dart';

extension TestStoreExt<Key, Output> on Store<Key, Output> {
  Future<StoreResponse<Output>> getData(Key key) =>
      stream(StoreRequest.cached(key, false))
          .firstWhere((element) => !(element is LoadingStoreResponse))
          .then((value) => StoreResponse.data<Output>(
              origin: value.origin, value: value.requireData()));
}
