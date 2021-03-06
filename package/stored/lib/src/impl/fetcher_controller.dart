import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart' show internal;
import 'package:rxdart/rxdart.dart';
import 'package:stored/src/fetcher.dart';
import 'package:stored/src/impl/ref_counted_resource.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';
import 'package:stored/src/store_response.dart';

/// This class maintains one and only 1 fetcher for a given [Key].
///
/// Any value emitted by the fetcher is sent into the [sourceOfTruth] before it is dispatched.
/// If [sourceOfTruth] is `null`, [enablePiggyback] is set to true by default so that previous
/// fetcher requests receives values dispatched by later requests even if they don't share the
/// request.
@internal
class FetcherController<Key, Input, Output> {
  final Fetcher<Key, Input> _realFetcher;
  final SourceOfTruthWithBarrier<Key, Input, Output>? sourceOfTruth;
  final _logger = Logger('FetcherController');

  FetcherController(this._realFetcher, {this.sourceOfTruth});

  late final fetchers =
      RefCountedResource<Key, Stream<StoreResponse<Input>>>((key) {
    final _subject = BehaviorSubject<FetcherResult<Input>>();
    _subject.addStream(_realFetcher(key));
    return _subject.stream
        .map((event) {
          return event.map(
              data: (value) => StoreResponse.data<Input>(
                  origin: ResponseOrigin.Fetcher, value: value.data as Input),
              error: (error) => StoreResponse.error<Input>(
                  error: error, origin: ResponseOrigin.Fetcher));
        })
        .defaultIfEmpty(
            StoreResponse.noNewData<Input>(origin: ResponseOrigin.Fetcher))
        .doOnData((event) {
          final input = event.dataOrNull();
          if (input != null) {
            sourceOfTruth?.write(key, input);
          }
        });
  });

  Stream<StoreResponse<Input>> getFetcher(Key key,
      {bool piggybackOnly = false}) async* {
    _logger.info('getFetcher for $key');
    final fetcher = await _acquireFetcher(key);
    try {
      yield* fetcher;
    } finally {
      await fetchers.release(key, fetcher);
    }
  }

  Future<Stream<StoreResponse<Input>>> _acquireFetcher(Key key) {
    _logger.info('_acquireFetcher for $key');
    return fetchers.acquire(key);
  }

  @visibleForTesting
  Future<int> get fetcherSize => fetchers.size;
}
