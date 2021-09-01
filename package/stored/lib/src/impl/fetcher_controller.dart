import 'package:meta/meta.dart' show internal;
import 'package:stored/src/fetcher.dart';
import 'package:stored/src/impl/ref_counted_resource.dart';
import 'package:stored/src/impl/source_of_truth_with_barrier.dart';

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

  FetcherController(this._realFetcher, {this.sourceOfTruth});


  final fetchers = RefCountedResource((key) {

    Multicaster

  })
}
