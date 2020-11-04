import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertaladsod/domain/core/value_objects.dart';
import 'package:fluttertaladsod/domain/location/location.dart';
import 'package:fluttertaladsod/domain/store/i_store_repository.dart';
import 'package:fluttertaladsod/domain/store/store.dart';
import 'package:fluttertaladsod/domain/store/store_failures.dart';
import 'package:fluttertaladsod/infrastucture/store/store_dto.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertaladsod/infrastucture/core/firestore_helper.dart';

@prod
@LazySingleton(as: IStoreRepository)
class StoreRepository implements IStoreRepository {
  final FirebaseFirestore _firestore;
  final StorageReference _storage;
  final Geoflutterfire _geo;

  StoreRepository(this._firestore, this._storage, this._geo);

  @override
  Stream<Either<StoreFailure, List<Store>>> watchNearbyStore({
    @required double rad,
    @required LocationDomain location,
    @required BehaviorSubject<double> radius,
  }) async* {
    assert(rad != null);
    assert(location != null);

    yield* radius
        .switchMap((rad) => _geo
            .collection(collectionRef: _firestore.storeCollectionRef)
            .within(
              center: location.geoFirePoint,
              radius: rad,
              field: 'location',
              strictMode: true,
            ))
        .map(
      (snapshots) {
        if (snapshots.isEmpty) {
          return left<StoreFailure, List<Store>>(StoreFailure.noStore());
        }
        print('store repo: returning stores');
        return right<StoreFailure, List<Store>>(
          snapshots.map(
            (snap) {
              final geoPoint = snap.data()['location']['geopoint'] as GeoPoint;
              final distanceAway = location.geoFirePoint.distance(
                lat: geoPoint.latitude,
                lng: geoPoint.longitude,
              );
              return StoreDto.fromFirestore(snap: snap, location: location)
                  .toDomain()
                  .copyWith(distanceAway: distanceAway.toInt());
            },
          ).toList(),
        );
      },
    ).handleError(
      (err) {
        // log error onto the console here
        return left<StoreFailure, List<Store>>(StoreFailure.unexpected());
      },
    );
  }

  @override
  Stream<Either<StoreFailure, Store>> watchSingleStore({
    @required UniqueId storeId,
    @required LocationDomain location,
  }) async* {
    yield* _firestore.storeCollectionRef.doc(storeId.getOrCrash()).snapshots().map((snap) {
      if (!snap.exists) {
        return left<StoreFailure, Store>(StoreFailure.noStore());
      } else {
        return right<StoreFailure, Store>(
            StoreDto.fromFirestore(snap: snap, location: location).toDomain());
      }
    }).handleError((err) {
      // print error onto the console here
      return left<StoreFailure, Store>(StoreFailure.unexpected());
    });
  }

  @override
  Stream<Either<StoreFailure, Store>> watchOwnedStore({
    @required UniqueId ownerId,
    @required LocationDomain location,
  }) async* {
    yield* _firestore.storeCollectionRef
        .where('ownerId', isEqualTo: ownerId.getOrCrash())
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return left<StoreFailure, Store>(StoreFailure.noStore());
      } else {
        return right<StoreFailure, Store>(snapshot.docs
            .map(
              (doc) => StoreDto.fromFirestore(snap: doc, location: location).toDomain(),
            )
            .toList()
            .first);
      }
    }).handleError((err) {
      // log error onto the console here
      return left<StoreFailure, Store>(StoreFailure.unexpected());
    });
  }

  @override
  Future<Either<StoreFailure, Unit>> create(
      Store store, LocationDomain location) async {
    final userDoc = await _firestore.userDocument();
    final jsonData = StoreDto.fromDomain(store).toJson()
      ..addEntries(
        [
          MapEntry('location', location.geoFirePoint.data),
          MapEntry('ownerId', userDoc.id),
        ],
      );
    try {
      _firestore.storeCollectionRef.doc(UniqueId().getOrCrash()).set(jsonData);
    } catch (err) {
      return left(StoreFailure.unexpected());
    }
    return right(unit);
  }

  @override
  Future<Either<StoreFailure, Unit>> update(Store store,
      {LocationDomain location}) async {
    final jsonData = StoreDto.fromDomain(store).toJson()
      ..addEntries([MapEntry('location', location?.geoFirePoint?.data)]);

    try {
      _firestore.storeCollectionRef.doc(store.id.getOrCrash()).update(jsonData);
    } catch (err) {
      return left(StoreFailure.unexpected());
    }
    return right(unit);
  }

  @override
  Future<Either<StoreFailure, Unit>> delete(UniqueId storeId) async {
    try {
      await _firestore.storeCollectionRef.doc(storeId.getOrCrash()).delete();
      return right(unit);
    } catch (err) {
      return left(StoreFailure.unexpected());
    }
  }

  @override
  Future<Either<StoreFailure, String>> uploadFileImage(
      File img, String path) async {
    final imageId = Uuid().v4();
    try {
      // upload (path in firebase storage)
      final StorageUploadTask uploadTask =
          _storage.child("$path/img_$imageId").putFile(img);

      // wait for completion
      final StorageTaskSnapshot storageSnap = await uploadTask.onComplete;

      //get download Url
      final String mediaUrl = await storageSnap.ref.getDownloadURL() as String;
      return right(mediaUrl);
    } catch (err) {
      // log error here
      return left(StoreFailure.unexpected());
    }
  }
}
