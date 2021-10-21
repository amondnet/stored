import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:quiver/check.dart';
import 'package:synchronized/synchronized.dart';

/// Simple holder that can ref-count items by a given key.
@internal
class RefCountedResource<Key, T> {
  final _logger = Logger('RefCountedResource');
  final T Function(Key) _create;
  final Future<void> Function(Key, T)? _onRelease;

  final _items = <Key, _Item>{};
  final _lock = Lock();

  RefCountedResource(this._create, {Future<void> Function(Key, T)? onRelease})
      : _onRelease = onRelease;

  Future<T> acquire(Key key) => _lock.synchronized(() {
        _logger.finest('acquire for $key');
        final value =
            (_items.putIfAbsent(key, () => _Item(_create(key)))..inc()).value;
        _logger.finest('value is $value');
        return value;
      });

  Future<void> release(Key key, T value) => _lock.synchronized(() {
        _logger.finest('release for $key');

        final existing = _items[key];
        checkState(existing != null && existing.value == value,
            message:
                'inconsistent release, seems like $value was leaked or never acquired');
        existing!.refCount--;
        if (existing.refCount < 1) {
          _items.remove(key);
          _onRelease?.call(key, value);
          print('removed');
          print('items : ${_items.length}');
        }
      }).whenComplete(() => _logger.finest('released for $key'));

  @visibleForTesting
  Future<int> get size => _lock.synchronized(() => _items.length);
}

class _Item<T> {
  final T value;
  int refCount = 0;

  _Item(this.value);

  void inc() => refCount++;
}
