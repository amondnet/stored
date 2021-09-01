import 'package:async/async.dart';

class Multicaster<T> {
  final StreamSplitter<T> _inFlight;

  Multicaster(
    Stream<T> source,
    Future Function(T) onEach,
  ) : _inFlight = StreamSplitter<T>(source) {
    _inFlight.split().listen((event) {
      onEach(event);
    });
  }
}
