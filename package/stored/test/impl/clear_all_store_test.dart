import 'package:stored/stored.dart';
import 'package:test/test.dart';

import '../testutils/in_memory_persister.dart';
import '../testutils/test_store_ext.dart';

void main() {
  const key1 = 'key1';
  const key2 = 'key2';
  final value1 = 1;
  final value2 = 2;

  final fetcher = Fetcher.of((key) async {
    switch (key) {
      case key1:
        return value1;
      case key2:
        return value2;
      default:
        throw StateError('Unknown key');
    }
  });
  final persister = InMemoryPersister<String, int>();

  test(
      'calling clearAll() on store with persister (no in-memory cache) deletes all entries from the persister',
      () async {
    final store =
        StoreBuilder.from(fetcher, sourceOfTruth: persister.asSourceOfTruth())
            .disableCache()
            .build();

    // should receive data from network first time
    expect(await store.getData(key1),
        StoreResponse.data(origin: ResponseOrigin.Fetcher, value: value1));
    expect(await store.getData(key2),
        StoreResponse.data(origin: ResponseOrigin.Fetcher, value: value2));

    // should receive data from persister
    expect(
        await store.getData(key1),
        StoreResponse.data(
            origin: ResponseOrigin.SourceOfTruth, value: value1));
    expect(
        await store.getData(key2),
        StoreResponse.data(
            origin: ResponseOrigin.SourceOfTruth, value: value2));
  });
}
