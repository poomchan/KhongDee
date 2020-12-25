import 'package:dartz/dartz.dart';
import 'package:fluttertaladsod/domain/user/user.dart';
import 'package:fluttertaladsod/domain/user/user_failure.dart';

abstract class IUserRepository {
  Future<Either<UserFailure, Unit>> updateUser(UserDomain user);
  Future<Either<UserFailure, UserDomain>> getUser(String uid);
}