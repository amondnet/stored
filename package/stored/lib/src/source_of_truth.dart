import 'package:stored/src/impl/real_source_of_truth.dart';

import 'store.dart';
import 'store_response.dart';

abstract class SourceOfTruth<Key, Input, Output> {
  /// Used by [Store] to read records from the source of truth.
  ///
  /// [key] : The key to read for.
  Stream<Output?> reader(Key key);

  /// Used by [Store] to write records **coming in from the fetcher (network)** to the source of
  /// truth.
  ///
  /// **Note:** [Store] currently does not support updating the source of truth with local user
  /// updates (i.e writing record of type [Output]). However, any changes in the local database
  /// will still be visible via [Store.stream] APIs as long as you are using a local storage that
  /// supports observability (e.g. Hive, Sqflite, Realm).
  ///
  /// [key] : The key to update for.
  Future<void> write(Key key, Input value);

  /// Used by [Store] to delete records in the source of truth for the given key.
  ///
  /// [key] : The key to delete for.
  Future<void> delete(Key key);

  /// Used by [Store] to delete all records in the source of truth.
  Future<void> deleteAll();

  /// Creates a (non-[Stream]) source of truth that is accessible via [futureReader], [writer],
  /// [delete] and [deleteAll].
  ///
  /// [futureReader] function for reading records from the source of truth
  /// [writer] function for writing updates to the backing source of truth
  /// [delete] function for deleting records in the source of truth for the given key
  /// [deleteAll] function for deleting all records in the source of truth
  static SourceOfTruth<Key, Input, Output> of<Key, Input, Output>(
    FutureReader<Key, Output> futureReader,
    Writer<Key, Input> writer,
    Delete<Key> delete,
    DeleteAll deleteAll,
  ) =>
      PersistentNonStreamingSourceOfTruth(futureReader, writer,
          realDelete: delete, realDeleteAll: deleteAll);

  static SourceOfTruth<Key, Input, Output> ofStream<Key, Input, Output>(
    StreamReader<Key, Output> streamReader,
    Writer<Key, Input> writer,
    Delete<Key> delete,
    DeleteAll deleteAll,
  ) =>
      PersistentSourceOfTruth(streamReader, writer,
          realDelete: delete, realDeleteAll: deleteAll);
}

typedef FutureReader<Key, Output> = Future<Output?> Function(Key);
typedef StreamReader<Key, Output> = Stream<Output?> Function(Key);

typedef Writer<Key, Input> = Future<void> Function(Key, Input);
typedef Delete<Key> = Future<void> Function(Key);
typedef DeleteAll = Future<void> Function();

/// The exception provided when a write operation fails in [SourceOfTruth].
///
/// see [ExceptionStoreResponse]
class WriteException implements Exception {
  final dynamic key;
  final dynamic value;
  final dynamic cause;

  /// The [key] for the failed write attempt
  /// The [value] for the failed write attempt
  /// The [cause] thrown from the [SourceOfTruth.write] method.
  WriteException({this.key, this.value, required this.cause});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WriteException &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value &&
          cause == other.cause;

  @override
  int get hashCode {
    var result = key.hashCode;
    result = 31 * result + value.hashCode;
    return result;
  }
}

/// Exception created when a [SourceOfTruth.reader] throws an exception.
///
/// see [ExceptionStoreResponse]
class ReadException implements Exception {
  /// The key for the failed write attempt
  final dynamic key;
  final dynamic cause;

  ReadException({this.key, required this.cause});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadException &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          cause == other.cause;

  @override
  int get hashCode => key.hashCode;
}
