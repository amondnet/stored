// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'fetcher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FetcherResultTearOff {
  const _$FetcherResultTearOff();

  DataFetcherResult<T> data<T>(T data) {
    return DataFetcherResult<T>(
      data,
    );
  }

  ErrorFetcherResult<T> error<T>(dynamic error) {
    return ErrorFetcherResult<T>(
      error,
    );
  }
}

/// @nodoc
const $FetcherResult = _$FetcherResultTearOff();

/// @nodoc
mixin _$FetcherResult<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(dynamic error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataFetcherResult<T> value) data,
    required TResult Function(ErrorFetcherResult<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FetcherResultCopyWith<T, $Res> {
  factory $FetcherResultCopyWith(
          FetcherResult<T> value, $Res Function(FetcherResult<T>) then) =
      _$FetcherResultCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$FetcherResultCopyWithImpl<T, $Res>
    implements $FetcherResultCopyWith<T, $Res> {
  _$FetcherResultCopyWithImpl(this._value, this._then);

  final FetcherResult<T> _value;
  // ignore: unused_field
  final $Res Function(FetcherResult<T>) _then;
}

/// @nodoc
abstract class $DataFetcherResultCopyWith<T, $Res> {
  factory $DataFetcherResultCopyWith(DataFetcherResult<T> value,
          $Res Function(DataFetcherResult<T>) then) =
      _$DataFetcherResultCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$DataFetcherResultCopyWithImpl<T, $Res>
    extends _$FetcherResultCopyWithImpl<T, $Res>
    implements $DataFetcherResultCopyWith<T, $Res> {
  _$DataFetcherResultCopyWithImpl(
      DataFetcherResult<T> _value, $Res Function(DataFetcherResult<T>) _then)
      : super(_value, (v) => _then(v as DataFetcherResult<T>));

  @override
  DataFetcherResult<T> get _value => super._value as DataFetcherResult<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(DataFetcherResult<T>(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$DataFetcherResult<T> implements DataFetcherResult<T> {
  _$DataFetcherResult(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'FetcherResult<$T>.data(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is DataFetcherResult<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  $DataFetcherResultCopyWith<T, DataFetcherResult<T>> get copyWith =>
      _$DataFetcherResultCopyWithImpl<T, DataFetcherResult<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(dynamic error) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataFetcherResult<T> value) data,
    required TResult Function(ErrorFetcherResult<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class DataFetcherResult<T> implements FetcherResult<T> {
  factory DataFetcherResult(T data) = _$DataFetcherResult<T>;

  T get data => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataFetcherResultCopyWith<T, DataFetcherResult<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorFetcherResultCopyWith<T, $Res> {
  factory $ErrorFetcherResultCopyWith(ErrorFetcherResult<T> value,
          $Res Function(ErrorFetcherResult<T>) then) =
      _$ErrorFetcherResultCopyWithImpl<T, $Res>;
  $Res call({dynamic error});
}

/// @nodoc
class _$ErrorFetcherResultCopyWithImpl<T, $Res>
    extends _$FetcherResultCopyWithImpl<T, $Res>
    implements $ErrorFetcherResultCopyWith<T, $Res> {
  _$ErrorFetcherResultCopyWithImpl(
      ErrorFetcherResult<T> _value, $Res Function(ErrorFetcherResult<T>) _then)
      : super(_value, (v) => _then(v as ErrorFetcherResult<T>));

  @override
  ErrorFetcherResult<T> get _value => super._value as ErrorFetcherResult<T>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(ErrorFetcherResult<T>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$ErrorFetcherResult<T> implements ErrorFetcherResult<T> {
  _$ErrorFetcherResult(this.error);

  @override
  final dynamic error;

  @override
  String toString() {
    return 'FetcherResult<$T>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ErrorFetcherResult<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $ErrorFetcherResultCopyWith<T, ErrorFetcherResult<T>> get copyWith =>
      _$ErrorFetcherResultCopyWithImpl<T, ErrorFetcherResult<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function(dynamic error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function(dynamic error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataFetcherResult<T> value) data,
    required TResult Function(ErrorFetcherResult<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(ErrorFetcherResult<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorFetcherResult<T> implements FetcherResult<T> {
  factory ErrorFetcherResult(dynamic error) = _$ErrorFetcherResult<T>;

  dynamic get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ErrorFetcherResultCopyWith<T, ErrorFetcherResult<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
