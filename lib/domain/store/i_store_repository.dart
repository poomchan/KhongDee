import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertaladsod/domain/auth/user/user.dart';
import 'package:fluttertaladsod/domain/core/value_objects.dart';
import 'package:fluttertaladsod/domain/location/location.dart';
import 'package:fluttertaladsod/domain/store/store.dart';
import 'package:fluttertaladsod/domain/store/store_failures.dart';
import 'package:rxdart/subjects.dart';

abstract class IStoreRepository {
  Stream<Either<StoreFailure, Store>> watchOwnedStore({
    @required UniqueId ownerId,
    @required LocationDomain location,
    @required UserDomain user,
  });
  Stream<Either<StoreFailure, List<Store>>> watchNearbyStore({
    @required LocationDomain location,
    @required BehaviorSubject<double> rad,
    @required Option<UserDomain> userOption,
  });

  Stream<Either<StoreFailure, Store>> watchSingleStore({
    @required UniqueId storeId,
    @required LocationDomain location,
    @required Option<UserDomain> userOption,
  });

  Future<Either<StoreFailure, String>> uploadFileImage(File img, String path);

  Future<Either<StoreFailure, Unit>> create(Store store);
  Future<Either<StoreFailure, Unit>> update(Store store);
  Future<Either<StoreFailure, Unit>> delete(UniqueId storeId);
}
