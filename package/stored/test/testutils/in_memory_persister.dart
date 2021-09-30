import 'package:stored/src/source_of_truth.dart';

/// An in-memory non-streaming persister for testing.
class InMemoryPersister<Key, Output> {
  final _data = <Key, Output>{};

  Future<Output> Function(Key, Output)? preWriteCallback;
  Future<Output?> Function(Key, Output?)? postReadCallback;

  Future<Output?> read(Key key) async {
    print('read');
    final value = _data[key];
    await postReadCallback?.call(key, value);

    return value;
  }

  Future<void> write(Key key, Output output) async {
    final value = await preWriteCallback?.call(key, output) ?? output;
    _data[key] = value;
  }

  Future<void> deleteByKey(Key key) async {
    _data.remove(key);
  }

  Future<void> deleteAll() async {
    _data.clear();
  }

  Output? peekEntry(Key key) {
    return _data[key];
  }

  SourceOfTruth<Key, Output, Output> asSourceOfTruth() {
    return SourceOfTruth.of<Key, Output, Output>(
        read, write, deleteByKey, deleteAll);
  }
}
