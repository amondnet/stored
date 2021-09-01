// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

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

  _ErrorFetcherResult<T> error<T>() {
    return _ErrorFetcherResult<T>();
  }
}

/// @nodoc
const $FetcherResult = _$FetcherResultTearOff();

/// @nodoc
mixin _$FetcherResult<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function() error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function()? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataFetcherResult<T> value) data,
    required TResult Function(_ErrorFetcherResult<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(_ErrorFetcherResult<T> value)? error,
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
    required TResult Function() error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function()? error,
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
    required TResult Function(_ErrorFetcherResult<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(_ErrorFetcherResult<T> value)? error,
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
abstract class _$ErrorFetcherResultCopyWith<T, $Res> {
  factory _$ErrorFetcherResultCopyWith(_ErrorFetcherResult<T> value,
          $Res Function(_ErrorFetcherResult<T>) then) =
      __$ErrorFetcherResultCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$ErrorFetcherResultCopyWithImpl<T, $Res>
    extends _$FetcherResultCopyWithImpl<T, $Res>
    implements _$ErrorFetcherResultCopyWith<T, $Res> {
  __$ErrorFetcherResultCopyWithImpl(_ErrorFetcherResult<T> _value,
      $Res Function(_ErrorFetcherResult<T>) _then)
      : super(_value, (v) => _then(v as _ErrorFetcherResult<T>));

  @override
  _ErrorFetcherResult<T> get _value => super._value as _ErrorFetcherResult<T>;
}

/// @nodoc

class _$_ErrorFetcherResult<T> implements _ErrorFetcherResult<T> {
  _$_ErrorFetcherResult();

  @override
  String toString() {
    return 'FetcherResult<$T>.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _ErrorFetcherResult<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) data,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? data,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DataFetcherResult<T> value) data,
    required TResult Function(_ErrorFetcherResult<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DataFetcherResult<T> value)? data,
    TResult Function(_ErrorFetcherResult<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ErrorFetcherResult<T> implements FetcherResult<T> {
  factory _ErrorFetcherResult() = _$_ErrorFetcherResult<T>;
}

/// @nodoc
class _$ErrorFetcherResultTearOff {
  const _$ErrorFetcherResultTearOff();

  ExceptionErrorFetcherResult exception(Exception exception) {
    return ExceptionErrorFetcherResult(
      exception,
    );
  }

  MessageErrorFetcherResult message(String message) {
    return MessageErrorFetcherResult(
      message,
    );
  }
}

/// @nodoc
const $ErrorFetcherResult = _$ErrorFetcherResultTearOff();

/// @nodoc
mixin _$ErrorFetcherResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exception exception) exception,
    required TResult Function(String message) message,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exception exception)? exception,
    TResult Function(String message)? message,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExceptionErrorFetcherResult value) exception,
    required TResult Function(MessageErrorFetcherResult value) message,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExceptionErrorFetcherResult value)? exception,
    TResult Function(MessageErrorFetcherResult value)? message,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorFetcherResultCopyWith<$Res> {
  factory $ErrorFetcherResultCopyWith(
          ErrorFetcherResult value, $Res Function(ErrorFetcherResult) then) =
      _$ErrorFetcherResultCopyWithImpl<$Res>;
}

/// @nodoc
class _$ErrorFetcherResultCopyWithImpl<$Res>
    implements $ErrorFetcherResultCopyWith<$Res> {
  _$ErrorFetcherResultCopyWithImpl(this._value, this._then);

  final ErrorFetcherResult _value;
  // ignore: unused_field
  final $Res Function(ErrorFetcherResult) _then;
}

/// @nodoc
abstract class $ExceptionErrorFetcherResultCopyWith<$Res> {
  factory $ExceptionErrorFetcherResultCopyWith(
          ExceptionErrorFetcherResult value,
          $Res Function(ExceptionErrorFetcherResult) then) =
      _$ExceptionErrorFetcherResultCopyWithImpl<$Res>;
  $Res call({Exception exception});
}

/// @nodoc
class _$ExceptionErrorFetcherResultCopyWithImpl<$Res>
    extends _$ErrorFetcherResultCopyWithImpl<$Res>
    implements $ExceptionErrorFetcherResultCopyWith<$Res> {
  _$ExceptionErrorFetcherResultCopyWithImpl(ExceptionErrorFetcherResult _value,
      $Res Function(ExceptionErrorFetcherResult) _then)
      : super(_value, (v) => _then(v as ExceptionErrorFetcherResult));

  @override
  ExceptionErrorFetcherResult get _value =>
      super._value as ExceptionErrorFetcherResult;

  @override
  $Res call({
    Object? exception = freezed,
  }) {
    return _then(ExceptionErrorFetcherResult(
      exception == freezed
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as Exception,
    ));
  }
}

/// @nodoc

class _$ExceptionErrorFetcherResult implements ExceptionErrorFetcherResult {
  _$ExceptionErrorFetcherResult(this.exception);

  @override
  final Exception exception;

  @override
  String toString() {
    return 'ErrorFetcherResult.exception(exception: $exception)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ExceptionErrorFetcherResult &&
            (identical(other.exception, exception) ||
                const DeepCollectionEquality()
                    .equals(other.exception, exception)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(exception);

  @JsonKey(ignore: true)
  @override
  $ExceptionErrorFetcherResultCopyWith<ExceptionErrorFetcherResult>
      get copyWith => _$ExceptionErrorFetcherResultCopyWithImpl<
          ExceptionErrorFetcherResult>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exception exception) exception,
    required TResult Function(String message) message,
  }) {
    return exception(this.exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exception exception)? exception,
    TResult Function(String message)? message,
    required TResult orElse(),
  }) {
    if (exception != null) {
      return exception(this.exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExceptionErrorFetcherResult value) exception,
    required TResult Function(MessageErrorFetcherResult value) message,
  }) {
    return exception(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExceptionErrorFetcherResult value)? exception,
    TResult Function(MessageErrorFetcherResult value)? message,
    required TResult orElse(),
  }) {
    if (exception != null) {
      return exception(this);
    }
    return orElse();
  }
}

abstract class ExceptionErrorFetcherResult implements ErrorFetcherResult {
  factory ExceptionErrorFetcherResult(Exception exception) =
      _$ExceptionErrorFetcherResult;

  Exception get exception => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExceptionErrorFetcherResultCopyWith<ExceptionErrorFetcherResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageErrorFetcherResultCopyWith<$Res> {
  factory $MessageErrorFetcherResultCopyWith(MessageErrorFetcherResult value,
          $Res Function(MessageErrorFetcherResult) then) =
      _$MessageErrorFetcherResultCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class _$MessageErrorFetcherResultCopyWithImpl<$Res>
    extends _$ErrorFetcherResultCopyWithImpl<$Res>
    implements $MessageErrorFetcherResultCopyWith<$Res> {
  _$MessageErrorFetcherResultCopyWithImpl(MessageErrorFetcherResult _value,
      $Res Function(MessageErrorFetcherResult) _then)
      : super(_value, (v) => _then(v as MessageErrorFetcherResult));

  @override
  MessageErrorFetcherResult get _value =>
      super._value as MessageErrorFetcherResult;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(MessageErrorFetcherResult(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MessageErrorFetcherResult implements MessageErrorFetcherResult {
  _$MessageErrorFetcherResult(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ErrorFetcherResult.message(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is MessageErrorFetcherResult &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(message);

  @JsonKey(ignore: true)
  @override
  $MessageErrorFetcherResultCopyWith<MessageErrorFetcherResult> get copyWith =>
      _$MessageErrorFetcherResultCopyWithImpl<MessageErrorFetcherResult>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exception exception) exception,
    required TResult Function(String message) message,
  }) {
    return message(this.message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exception exception)? exception,
    TResult Function(String message)? message,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(this.message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExceptionErrorFetcherResult value) exception,
    required TResult Function(MessageErrorFetcherResult value) message,
  }) {
    return message(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExceptionErrorFetcherResult value)? exception,
    TResult Function(MessageErrorFetcherResult value)? message,
    required TResult orElse(),
  }) {
    if (message != null) {
      return message(this);
    }
    return orElse();
  }
}

abstract class MessageErrorFetcherResult implements ErrorFetcherResult {
  factory MessageErrorFetcherResult(String message) =
      _$MessageErrorFetcherResult;

  String get message => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageErrorFetcherResultCopyWith<MessageErrorFetcherResult> get copyWith =>
      throw _privateConstructorUsedError;
}
