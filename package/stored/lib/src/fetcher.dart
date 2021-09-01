import 'package:freezed_annotation/freezed_annotation.dart';
import 'store.dart';

part 'fetcher.freezed.dart';

@freezed
class FetcherResult<T> with _$FetcherResult {
  factory FetcherResult.data(T data) = DataFetcherResult;

  @internal
  factory FetcherResult.error() = _ErrorFetcherResult;
}

@freezed
class ErrorFetcherResult with _$ErrorFetcherResult, _ErrorFetcherResult<Null> {
  factory ErrorFetcherResult.exception(Exception exception) =
      ExceptionErrorFetcherResult;

  factory ErrorFetcherResult.message(String message) =
      MessageErrorFetcherResult;
}

typedef ResultStreamFactory<Key, Output> = Stream<FetcherResult<Output>>
    Function(Key k);
typedef StreamFactory<Key, Output> = Stream<Output> Function(Key k);

/// Fetcher is used by [Store] to fetch network records for a given key. The return type is [Flow] to
/// allow for multiple result per request.
///
/// Note: Store does not catch exceptions thrown by a [Fetcher]. This is done in order to avoid
/// silently swallowing NPEs and such. Use [ErrorFetcherResult] to communicate expected errors.
///
/// See [ofResult] for easily translating from a regular `suspend` function.
/// See [ofFlow], [of] for easily translating to [FetcherResult] (and
/// automatically transforming exceptions into [ErrorFetcherResult].
abstract class Fetcher<Key, Output> {
  Stream<FetcherResult<Output>> call(Key key);

  /// "Creates" a [Fetcher] from a [streamFactory].
  ///
  /// Use when creating a [Store] that fetches objects in a multiple responses per request
  /// network protocol (e.g Web Sockets).
  ///
  /// [Store] does not catch exception thrown in [streamFactory] or in the returned [Stream]. These
  /// exception will be propagated to the caller.
  ///
  /// @param flowFactory a factory for a [Flow]ing source of network records.
  static Fetcher<Key, Output> ofResultStream<Key, Output>(
          ResultStreamFactory<Key, Output> streamFactory) =>
      _FactoryFetcher<Key, Output>(streamFactory);

  /// "Creates" a [Fetcher] from a non-[Stream] source.
  ///
  /// Use when creating a [Store] that fetches objects in a single response per request network
  /// protocol (e.g Http).
  ///
  /// [Store] does not catch exception thrown in [doFetch]. These exception will be propagated to the
  /// caller.
  ///
  /// @param doFetch a source of network records.
  static Fetcher<Key, Output> ofResult<Key, Output>(
          Future<FetcherResult<Output>> Function(Key) doFetch) =>
      ofResultStream<Key, Output>((k) => doFetch(k).asStream());

  /// "Creates" a [Fetcher] from a [streamFactory] and translate the results to a [FetcherResult].
  ///
  /// Emitted values will be wrapped in [DataFetcherResult]. if an exception disrupts the flow then
  /// it will be wrapped in [ErrorFetcherResult]. Exceptions thrown in [streamFactory] itself are not
  /// caught and will be returned to the caller.
  ///
  /// Use when creating a [Store] that fetches objects in a multiple responses per request
  /// network protocol (e.g Web Sockets).
  ///
  /// @param flowFactory a factory for a [Flow]ing source of network records.
  static Fetcher<Key, Output> ofStream<Key, Output>(
      StreamFactory<Key, Output> streamFactory) {
    return _FactoryFetcher<Key, Output>((Key key) =>
        streamFactory(key).map((event) => DataFetcherResult(event)));
  }

  /// "Creates" a [Fetcher] from a non-[Flow] source and translate the results to a [FetcherResult].
  ///
  /// Emitted values will be wrapped in [DataFetcherResult]. if an exception disrupts the flow then
  /// it will be wrapped in [ErrorFetcherResult]
  ///
  /// Use when creating a [Store] that fetches objects in a single response per request
  /// network protocol (e.g Http).
  ///
  /// [doFetch] a source of network records.
  static Fetcher<Key, Output> of<Key, Output>(
      Future<Output> Function(Key) doFetch) {
    return ofStream((k) => doFetch(k).asStream());
  }
}

class _FactoryFetcher<Key, OutPut> extends Fetcher<Key, OutPut> {
  final ResultStreamFactory<Key, OutPut> _factory;

  _FactoryFetcher(this._factory);

  @override
  Stream<FetcherResult<OutPut>> call(Key key) => _factory(key);
}
