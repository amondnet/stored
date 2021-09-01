import 'package:stored/src/exceptions.dart';
import 'package:stored/src/store_response.dart';
import 'package:test/test.dart';

void main() {
  test('require data', () {
    expect(
        StoreResponse.data(origin: ResponseOrigin.Fetcher, value: 'foo')
            .requireData(),
        'foo');
    expect(
        () =>
            StoreResponse.loading(origin: ResponseOrigin.Fetcher).requireData(),
        throwsA(isA<NullPointerException>()));
  });
}
