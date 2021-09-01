import 'package:freezed_annotation/freezed_annotation.dart';

import 'exceptions.dart';

/// Holder for responses from Store.
///
/// Instead of using regular error channels (a.k.a. throwing exceptions), Store uses this holder
/// class to represent each response. This allows the flow to keep running even if an error happens
/// so that if there is an observable single source of truth, application can keep observing it.

@sealed
abstract class StoreResponse<T> {
  final ResponseOrigin origin;

  StoreResponse(this.origin);

  static StoreResponse<T> data<T>(
          {required ResponseOrigin origin, required T value}) =>
      DataStoreResponse<T>(value, origin);

  static StoreResponse<Null> loading({required ResponseOrigin origin}) =>
      LoadingStoreResponse(origin);

  T requireData() {
    if (this is DataStoreResponse) {
      return (this as DataStoreResponse).value;
    } else if (this is ErrorStoreResponse) {
      (this as ErrorStoreResponse).doThrow();
    }
    throw NullPointerException('there is no data in $this');
  }

  /// If this [StoreResponse] is of type [ErrorStoreResponse], throws the exception
  /// Otherwise, does nothing.
  void throwIfError() {
    if (this is ErrorStoreResponse) {
      (this as ErrorStoreResponse).doThrow();
    }
  }

  /// If this [StoreResponse] is of type [ErrorStoreResponse], returns the available error
  /// from it. Otherwise, returns `null`.
  String? errorMessageOrNull() {
    if (this is ErrorMessageStoreResponse) {
      return (this as ErrorMessageStoreResponse).message;
    } else if (this is ExceptionStoreResponse) {
      return (this as ExceptionStoreResponse).error.toString();
    }
  }

  T? dataOrNull() {
    if (this is DataStoreResponse) {
      return (this as DataStoreResponse).value;
    }
    return null;
  }

  @internal
  @optionalTypeArgs
  StoreResponse<R> swapType<R>() {
    if (this is ErrorStoreResponse) {
      return this as StoreResponse<R>;
    } else if (this is LoadingStoreResponse) {
      return this as StoreResponse<R>;
    } else if (this is NoNewDataStoreResponse) {
      return this as StoreResponse<R>;
    } else if (this is DataStoreResponse) {
      throw Exception('cannot swap type for DataStoreResponse');
    } else {
      throw StateError('');
    }
  }
}

class LoadingStoreResponse extends StoreResponse<Null> {
  LoadingStoreResponse(ResponseOrigin origin) : super(origin);
}

class DataStoreResponse<T> extends StoreResponse<T> {
  final T value;

  DataStoreResponse(this.value, ResponseOrigin origin) : super(origin);
}

class NoNewDataStoreResponse extends StoreResponse<Null> {
  NoNewDataStoreResponse(ResponseOrigin origin) : super(origin);
}

@sealed
abstract class ErrorStoreResponse extends StoreResponse<Null> {
  ErrorStoreResponse(ResponseOrigin origin) : super(origin);
}

class ExceptionStoreResponse extends ErrorStoreResponse {
  final Exception error;

  ExceptionStoreResponse(this.error, ResponseOrigin origin) : super(origin);
}

class ErrorMessageStoreResponse extends ErrorStoreResponse {
  final String message;

  ErrorMessageStoreResponse(this.message, ResponseOrigin origin)
      : super(origin);
}

/// Represents the origin for a [StoreResponse].
enum ResponseOrigin {
  /// [StoreResponse] is sent from the cache
  Cache,

  /// [StoreResponse] is sent from the persister
  SourceOfTruth,

  /// [StoreResponse] is sent from a fetcher,
  Fetcher,
}

extension on ErrorStoreResponse {
  void doThrow() {
    if (this is ExceptionStoreResponse) {
      throw (this as ExceptionStoreResponse).error;
    } else if (this is ErrorMessageStoreResponse) {
      throw Exception((this as ErrorMessageStoreResponse).message);
    }
  }
}
