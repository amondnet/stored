import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stored/src/impl/real_source_of_truth.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store_response.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import 'testutils/in_memory_persister.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((event) {
    print(event.message);
  });

  group('test for SourceOfTruthWithBarrier', () {
    final persister = InMemoryPersister<int, String>();

    final _reader = (key) async* {
      yield (await persister.read(key));
    };

    final delegate = PersistentSourceOfTruth<int, String, String>(
      _reader,
      persister.write,
      realDelete: persister.deleteByKey,
      realDeleteAll: persister.deleteAll,
    );

    late SourceOfTruthWithBarrier<int, String, String> source;

    setUp(() {
      source = SourceOfTruthWithBarrier(delegate);
    });

    tearDown(() {
      source.deleteAll();
    });

    test('simple', () async {
      final collector = source.reader(1, Future.value(1)).take(2);
      final completer = Completer();
      var index = 0;
      final sub = collector.listen((event) async {
        if (index++ == 0) {
          expect(
              event,
              StoreResponse.data<String?>(
                  origin: ResponseOrigin.SourceOfTruth, value: null));
          await source.write(1, 'a');
        } else {
          expect(
              event,
              StoreResponse.data<String?>(
                  origin: ResponseOrigin.Fetcher, value: 'a'));
        }

        completer.complete(Future.value(1));
      });
      //await source.write(1, 'a');

      /*
      await expectLater(
          collector,
          emitsInOrder([
            StoreResponse.data<String?>(
                origin: ResponseOrigin.SourceOfTruth, value: null),
            StoreResponse.data<String>(
                origin: ResponseOrigin.Fetcher, value: 'a')
          ]));
*/
      await completer.future;
      await sub.cancel();
      expect(await source.barrierCount, 0);
    });

    test(
        'Given a Source Of Truth WHEN delete is called THEN it is delegated to the persister',
        () async {
      await persister.write(1, 'a');
      await source.delete(1);
      expect(await persister.read(1), isNull);
    });

    test(
        'Given a Source Of Truth WHEN deleteAll is called THEN it is delegated to the persister',
        () async {
      await persister.write(1, 'a');
      await persister.write(2, 'b');

      await source.deleteAll();
      expect(await persister.read(1), isNull);
      expect(await persister.read(2), isNull);
    });

    test('pre and post writes', () async {
      await source.write(1, 'a');
      final collector = source.reader(1, Future.value(1)).take(2);

      final _completer = Completer();
      var index = 0;
      final sub = collector.listen((event) async {
        if (index++ == 0) {
          expect(
              event,
              equals(StoreResponse.data<String?>(
                  origin: ResponseOrigin.SourceOfTruth, value: 'a')));
          await source.write(1, 'b');
        } else {
          expect(
              event,
              equals(StoreResponse.data<String?>(
                  origin: ResponseOrigin.Fetcher, value: 'b')));
          _completer.complete(Future.value());
        }
      });

      await _completer.future;
      await sub.cancel();
      expect(await source.barrierCount, 0);
    });

    test('Given Source Of Truth WHEN read fails THEN error should propogate',
        () async {
      final exception = Exception('read fails');

      persister.postReadCallback = (k, v) {
        throw exception;
      };
      final stream = source.reader(1, Future.value());

      final completer = Completer();
      stream.listen((event) {
        expect(
            event,
            StoreResponse.error<String?>(
                error: ReadException(cause: exception, key: 1),
                origin: ResponseOrigin.SourceOfTruth));
        completer.complete(Future.value());
      });
      await completer.future;
    });

    test(
        'Given Source Of Truth WHEN read fails but then succeeds THEN error should propogate but also the value',
        () async {
      var hasThrown = false;
      final exception = Exception('read fails');
      persister.postReadCallback = (_, value) async {
        if (!hasThrown) {
          hasThrown = true;
          throw exception;
        }
        return value;
      };

      final reader = source.reader(1, Future.value());
      final completer = Completer();
      var index = 0;
      final collection = reader.listen((event) {
        if (index == 0) {
          expect(
              event,
              StoreResponse.error<String?>(
                  origin: ResponseOrigin.SourceOfTruth,
                  error: ReadException(key: 1, cause: exception)));
          source.write(1, 'a');
          index++;
        } else {
          expect(
              event,
              StoreResponse.data<String?>(
                  // this is fetcher since we are using the write API
                  origin: ResponseOrigin.Fetcher,
                  value: 'a'));
          completer.complete(Future.value());
        }
      });

      await completer.future;
      await collection.cancel();
    });

    test('Given Source Of Truth WHEN write fails THEN error should propogate',
        () async {
      final failValue = 'will fail';
      final exception = Exception('will fail');
      persister.preWriteCallback = (key, value) async {
        if (value == failValue) {
          throw exception;
        }
        return value;
      };

      final reader = source.reader(1, Future.value());
      final completer = Completer();
      var index = 0;

      final collected = [];

      final collection = reader.listen((event) async {
        if (index == 0) {
          expect(
              event,
              StoreResponse.data<String?>(
                  origin: ResponseOrigin.SourceOfTruth, value: null));
          index++;
          await source.write(1, failValue);
        } else if (index == 1) {
          expect(
            event,
            StoreResponse.error<String?>(
                origin: ResponseOrigin.SourceOfTruth,
                error:
                    WriteException(key: 1, value: failValue, cause: exception)),
          );
          index++;
        } else if (index == 2) {
          expect(
              event,
              StoreResponse.data<String?>(
                  origin: ResponseOrigin.SourceOfTruth, value: null));
          await source.write(1, 'succeed');
          index++;
        } else if (index == 3) {
          expect(
              event,
              StoreResponse.data<String?>(
                  origin: ResponseOrigin.Fetcher, value: 'succeed'));
          completer.complete(Future.value());
          index++;
        }
      });

      await completer.future;
      await collection.cancel();
    });
  });
}
