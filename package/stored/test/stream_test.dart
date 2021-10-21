import 'dart:async';
import 'package:stream_transform/stream_transform.dart';

import 'package:async/async.dart';
import 'package:test/test.dart';

void main() {
  test('aaa', () {
    expectLater(s2().merge(s1()), emitsInOrder([1, 2]));
  });
}

Completer completer = Completer();

Stream<int> s1() async* {
  await Future.delayed(Duration(seconds: 1));
  yield 1;
  completer.complete();
}

Stream<int> s2() async* {
  await completer.future;
  yield 2;
}
