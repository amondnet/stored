import 'package:quiver/check.dart';
import 'package:stored/src/fetcher.dart';
import 'package:test/test.dart';

class FakeFetcher<Key, Output> implements Fetcher<Key, Output> {
  int _index = 0;

  final List<MapEntry<Key, Output>> responses;

  FakeFetcher(Iterable<MapEntry<Key, Output>> responses)
      : responses = List.of(responses);

  @override
  Stream<FetcherResult<Output>> call(Key key) {
    checkState(_index <= responses.length);
    final entry = responses[_index++];
    //expect(entry.key, key);
    return Stream.value(FetcherResult.data(entry.value));
  }
}

class FakeStreamingFetcher<Key, Output> implements Fetcher<Key, Output> {
  final List<MapEntry<Key, Output>> responses;

  FakeStreamingFetcher(Iterable<MapEntry<Key, Output>> responses)
      : responses = List.of(responses);

  @override
  Stream<FetcherResult<Output>> call(Key key) async* {
    final filter = responses.where((element) => element.key == key);

    for (final entry in filter) {
      await Future.delayed(Duration(seconds: 1));
      yield FetcherResult.data(entry.value);
    }
  }
}
