import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stored/src/source_of_truth.dart';
import 'package:stored/src/store_builder.dart';
import 'package:stored/src/store_request.dart';
import 'package:stored/src/store_response.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'testutils/fake_fetcher.dart';
import 'testutils/in_memory_persister.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord event) {
    print('[${event.loggerName}] ${event.message}');
  });

  test(
      'GIVEN Source of Truth WHEN write fails THEN exception should be send to the collector',
      () async {
    final persister = InMemoryPersister<int, String>();
    final fetcher = FakeFetcher([MapEntry(3, 'a'), MapEntry(3, 'b')]);

    final pipeline =
        StoreBuilder.from(fetcher, sourceOfTruth: persister.asSourceOfTruth())
            .build();

    persister.preWriteCallback = (
      _,
      __,
    ) =>
        throw _TestException('i fail');

    var index = 0;
    late Completer awaiter = Completer();
    pipeline.stream(StoreRequest.fresh(3)).listen((event) {
      if (index++ == 0) {
        expect(event,
            StoreResponse.loading<String>(origin: ResponseOrigin.Fetcher));
      } else if (index++ == 1) {
        expect(event,
            StoreResponse.loading<String>(origin: ResponseOrigin.Fetcher));
        awaiter.complete();
      } else {
        awaiter.completeError('error');
      }
    });

    await awaiter.future;
  });

  test(
      'GIVEN Source of Truth WHEN read fails THEN exception should be send to the collector',
      () async {
    final persister = InMemoryPersister<int, String>();
    final fetcher = FakeFetcher([MapEntry(3, 'a'), MapEntry(3, 'b')]);

    final pipeline =
        StoreBuilder.from(fetcher, sourceOfTruth: persister.asSourceOfTruth())
            .build();

    persister.postReadCallback = (
      _,
      value,
    ) =>
        throw _TestException(value ?? 'null');

    var index = 0;
    late Completer awaiter = Completer();
    pipeline.stream(StoreRequest.fresh(3)).listen((event) {
      if (index++ == 0) {
        expect(
            event,
            StoreResponse.error(
                error: ReadException(key: 3, cause: _TestException('null')),
                origin: ResponseOrigin.SourceOfTruth));
      } else if (index++ == 1) {
        // after disk fails, we should still invoke fetcher
        expect(event,
            StoreResponse.loading<String>(origin: ResponseOrigin.Fetcher));
      } else if (index++ == 2) {
        // and after fetcher writes the value, it will trigger another read which will also
        // fail
        expect(
            event,
            StoreResponse.error(
                error: ReadException(key: 3, cause: _TestException('a')),
                origin: ResponseOrigin.SourceOfTruth));
        awaiter.complete();
      } else {
        awaiter.completeError('error');
      }
    });

    await awaiter.future;
  });
}

class _TestException implements Exception {
  final dynamic message;

  _TestException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return 'TestException';
    return 'TestException: $message';
  }

  @override
  int get hashCode => message.hashCode;
}
