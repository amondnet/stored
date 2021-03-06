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

  test('throwIfError Exception', () {
    expect(
        () => StoreResponse.error(
                error: Exception(''), origin: ResponseOrigin.Fetcher)
            .throwIfError(),
        throwsA(isA<Exception>()));
  });

  test('throwIfError Message', () {
    expect(
        () => StoreResponse.error(
                error: 'test error', origin: ResponseOrigin.Fetcher)
            .throwIfError(),
        throwsA(isA<Exception>()));
  });

  test('errorMessageOrNull', () {
    expect(
        StoreResponse.error(
                error: FormatException(), origin: ResponseOrigin.Fetcher)
            .errorMessageOrNull(),
        contains(FormatException().toString()));

    expect(
        StoreResponse.error(
                error: 'test error message', origin: ResponseOrigin.Fetcher)
            .errorMessageOrNull(),
        'test error message');

    expect(
        StoreResponse.loading(origin: ResponseOrigin.Fetcher)
            .errorMessageOrNull(),
        isNull);
  });

  test('swap type', () {
    expect(
        () => StoreResponse.data(origin: ResponseOrigin.Fetcher, value: 'Foo')
            .swapType<String>(),
        throwsA(isA<Exception>()));
  });

  test('swap type 2', () {
    final swap = StoreResponse.loading<String>(
      origin: ResponseOrigin.Fetcher,
    ).swapType<String>();
    expect(swap, isA<StoreResponse<String>>());
  });
}
