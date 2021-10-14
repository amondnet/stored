class Multicaster<T> {
  /// The buffer size that is used only if the upstream has not complete yet.
  /// Defaults to 0.
  var bufferSize = 0;
  final Stream<T> _source;

  /// If true, downstream is never closed by the multicaster unless upstream throws an error.
  /// Instead, it is kept open and if a new downstream shows up that causes us to restart the flow,
  /// it will receive values as well.
  final bool _piggybackingDownstream = false;

  /// If true, an active upstream will stay alive even if all downstreams are closed. A downstream
  /// coming in later will receive a value from the live upstream.
  ///
  /// The upstream will be kept alive until [close] is called.
  final bool _keepUpstreamAlive = false;
  final Future<void> Function(T value) _onEach;
}
