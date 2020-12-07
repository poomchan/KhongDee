import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@immutable
@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory AuthFailure.unauthenticated() = _Unauthenticated;
  const factory AuthFailure.serverError() = _SeverError;
}
