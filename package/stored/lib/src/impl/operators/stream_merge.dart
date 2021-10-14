import 'dart:async';

import 'package:async/async.dart';
import 'package:logging/logging.dart';

final _logger = Logger('StreamMerge');

extension StreamMerge<T> on Stream<T> {
  Stream<Either<T, R>> eitherMerge<R>(Stream<R> other) {
    return StreamGroup.merge([this, other]).transform(
        StreamTransformer<dynamic, Either<T, R>>.fromHandlers(
            handleData: (data, sink) {
      if (data is T) {
        sink.add(Either.left<T, R>(data));
      } else if (data is R) {
        sink.add(Either.right<T, R>(data));
      }
    }));
  }

  Stream<T> onStart(Future Function(EventSink<T> sink) action) {
    final _controller =
        isBroadcast ? StreamController<T>.broadcast() : StreamController<T>();

    action(_controller).then((value) {
      _logger.info('action complete, add stream');
      _controller.addStream(this);
    });

    return _controller.stream;
  }
}

abstract class Either<T, R> {
  static Either<T, R> left<T, R>(T value) => Left<T, R>(value);

  static Either<T, R> right<T, R>(R value) => Right<T, R>(value);

  Either._();
}

class Right<T, R> extends Either<T, R> {
  final R value;

  Right(this.value) : super._();
}

class Left<T, R> extends Either<T, R> {
  final T value;

  Left(this.value) : super._();
}
