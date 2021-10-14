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
      if (index == 0) {
        expect(event,
            StoreResponse.loading<String>(origin: ResponseOrigin.Fetcher));
      } else if (index == 1) {
        expect(event,
            StoreResponse.loading<String>(origin: ResponseOrigin.Fetcher));
        awaiter.complete();
      } else {
        expect(1, 2);
        awaiter.complete();
      }
    });
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
