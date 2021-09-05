import 'dart:async';

import 'package:stored/src/impl/real_source_of_truth.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store_response.dart';
import 'package:test/scaffolding.dart';
import 'package:test/test.dart';

import 'testutils/in_memory_persister.dart';

void main() {
  group('test for SourceOfTruthWithBarrier', () {
    final persister = InMemoryPersister<int, String>();
    final delegate = PersistentSourceOfTruth<int, String, String>(
      (key) => Stream.fromFuture(persister.read(key)),
      persister.write,
      realDelete: persister.deleteByKey,
      realDeleteAll: persister.deleteAll,
    );

    final source = SourceOfTruthWithBarrier(delegate);

    test('simple', () async {
      source.write(1, 'a');

      await expectLater(
          source.reader(1, Future.value(1)),
          emitsInOrder([
            StoreResponse.data<String?>(
                origin: ResponseOrigin.SourceOfTruth, value: null),
            StoreResponse.data<String>(
                origin: ResponseOrigin.Fetcher, value: 'a')
          ]));
    });
  });
}
