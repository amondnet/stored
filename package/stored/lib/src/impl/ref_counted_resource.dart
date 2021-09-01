import 'dart:async';

import 'package:meta/meta.dart';
import 'package:quiver/check.dart';
import 'package:synchronized/synchronized.dart';

/// Simple holder that can ref-count items by a given key.
@internal
class RefCountedResource<Key, T> {
  final T Function(Key) _create;
  final Future<void> Function(Key, T)? _onRelease;

  final _items = <Key, _Item>{};
  final _lock = Lock();

  RefCountedResource(this._create, {Future<void> Function(Key, T)? onRelease})
      : _onRelease = onRelease;

  Future<T> acquire(Key key) => _lock.synchronized(() {
        return (_items.putIfAbsent(key, () => _Item(_create(key)))..inc())
            .value;
      });

  Future<void> release(Key key, T value) => _lock.synchronized(() {
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
      });

  @visibleForTesting
  Future<int> get size => _lock.synchronized(() => _items.length);
}

class _Item<T> {
  final T value;
  int refCount = 0;

  _Item(this.value);

  void inc() => refCount++;
}
