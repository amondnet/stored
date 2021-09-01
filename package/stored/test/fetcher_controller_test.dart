import 'package:stored/src/impl/fetcher_controller.dart';
import 'package:stored/stored.dart';
import 'package:test/test.dart';
import 'package:async/async.dart';

void main() {
  group('tests for FetcherController', () {
    test('simple', () async {
      final fetcherController =
          FetcherController<int, int, int>(Fetcher.ofResultStream((k) async* {
        yield FetcherResult.data(k * k);
      }));

      final fetcher = fetcherController.getFetcher(3).asBroadcastStream();

      expect(await fetcherController.fetcherSize, 0);

      fetcher.listen(expectAsync1((event) async {
        expect(await fetcherController.fetcherSize, 1);
      }), onDone: () async {
        expect(await fetcherController.fetcherSize, 0);
      });

      final received = await fetcher.first;

      expect(received, DataStoreResponse(9, ResponseOrigin.Fetcher));
    });
  });

  test('concurrent', () async {
    var createdCnt = 0;

    final fetcherController =
        FetcherController<int, int, int>(Fetcher.ofResultStream((k) async* {
      createdCnt++;
      // make sure it takes time, otherwise, we may not share
      await Future.delayed(Duration(seconds: 1));
      yield FetcherResult.data(k * k);
    }));

    final fetcherCount = 20;

    final createFetcher = () {
      return fetcherController.getFetcher(3).first;
    };

    final group = FutureGroup<StoreResponse<int>>();

    for (var i = 0; i < fetcherCount; i++) {
      group.add(createFetcher());
    }

    expect(await fetcherController.fetcherSize, 0);

    group.close();

    final fetchers = await group.future;

    fetchers.forEach((element) {
      expect(element,
          StoreResponse.data(origin: ResponseOrigin.Fetcher, value: 9));
    });
    expect(await fetcherController.fetcherSize, 0);

    expect(createdCnt, 1);
  });
}
