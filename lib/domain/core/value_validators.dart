import 'package:dartz/dartz.dart';
import 'package:fluttertaladsod/domain/core/value_failures.dart';

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingLength(input, maxLength),
    );
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  final String filtered = input.replaceAll(RegExp(r"\s+"), "");
  if (filtered.isNotEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.empty(input));
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateUrlString(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<List<T>>, List<T>> validateMaxListLength<T>(
  List<T> input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(ValueFailure.listTooLong(input, maxLength));
  }
}

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure.shortPassword(input));
  }
}

Either<ValueFailure<double>, double> validateNumberIsPositive(double input) {
  if (input > 0) {
    return right(input);
  } else {
    return left(ValueFailure.numberNotPositive(input));
  }
}

Either<ValueFailure<T>, T> validateInputNotNull<T>(T input) {
    if (input == null) {
      return left(ValueFailure.nullValue());
    } else {
      return right(input);
    }
  }

