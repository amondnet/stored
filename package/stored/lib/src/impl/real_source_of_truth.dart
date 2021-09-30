import 'package:logging/logging.dart';
import 'package:stored/src/source_of_truth.dart';

class PersistentSourceOfTruth<Key, Input, Output>
    extends SourceOfTruth<Key, Input, Output> {
  final Stream<Output?> Function(Key) _realReader;
  final Future<void> Function(Key, Input) _realWriter;
  final Future<void> Function(Key)? _realDelete;
  final Future<void> Function()? _realDeleteAll;

  final Logger _logger = Logger('PersistentSourceOfTruth');

  PersistentSourceOfTruth(this._realReader, this._realWriter,
      {Future<void> Function(Key)? realDelete,
      Future<void> Function()? realDeleteAll})
      : _realDelete = realDelete,
        _realDeleteAll = realDeleteAll;

  @override
  Future<void> delete(Key key) async => _realDelete?.call(key);

  @override
  Future<void> deleteAll() async => _realDeleteAll?.call();

  @override
  Stream<Output?> reader(Key key) {
    _logger.finest('reader for $key');
    return _realReader(key);
  }

  @override
  Future<void> write(Key key, Input value) => _realWriter(key, value);
}

class PersistentNonStreamingSourceOfTruth<Key, Input, Output>
    extends SourceOfTruth<Key, Input, Output> {
  final Future<Output?> Function(Key) _realReader;
  final Future<void> Function(Key, Input) _realWriter;
  final Future<void> Function(Key)? _realDelete;
  final Future<void> Function()? _realDeleteAll;

  PersistentNonStreamingSourceOfTruth(this._realReader, this._realWriter,
      {Future<void> Function(Key)? realDelete,
      Future<void> Function()? realDeleteAll})
      : _realDelete = realDelete,
        _realDeleteAll = realDeleteAll;

  @override
  Future<void> delete(Key key) async => _realDelete?.call(key);

  @override
  Future<void> deleteAll() async => _realDeleteAll?.call();

  @override
  Stream<Output?> reader(Key key) => _realReader(key).asStream();

  @override
  Future<void> write(Key key, Input value) => _realWriter(key, value);
}
