import 'dart:async';
import 'package:fluttertaladsod/application/bloc/auth/auth_bloc.dart';
import 'package:fluttertaladsod/application/bloc/core/action_state.dart';
import 'package:fluttertaladsod/domain/location/i_location_repository.dart';
import 'package:fluttertaladsod/domain/store/i_store_repository.dart';
import 'package:fluttertaladsod/domain/store/store.dart';
import 'package:fluttertaladsod/domain/store/store_failures.dart';
import 'package:get/get.dart';

class OwnedStoreBloc extends GetxController
    with SimpleStateSetter<StoreFailure> {
  final IStoreRepository _iStoreRepo = Get.find<IStoreRepository>();
  final ILocationRepository _iLocationRepo = Get.find<ILocationRepository>();
  final _authBloc = Get.find<AuthBloc>();

  final _store = Store.created().obs;
  Store get store => _store.value;
  StreamSubscription _ownedStoreSub;

  Future<void> watchOwnedStoreStarted() async {
    setLoadingState();
    final locationOption = await _iLocationRepo.getLocation();
    final user = _authBloc.state.maybeWhen(
      loaded: () => _authBloc.user,
      orElse: () => throw 'user not authenticated',
    );

    locationOption.fold(
      (f) => setFailureState(StoreFailure.locationNotGranted()),
      (location) {
        _ownedStoreSub = _iStoreRepo
            .watchOwnedStore(
              ownerId: user.id,
              location: location,
              user: user,
            )
            .listen(
              (storeOrF) => storeOrF.fold(
                (f) => setFailureState(f),
                (store) {
                  _store.value = store;
                  setLoadedState();
                },
              ),
            );
      },
    );
  }

  @override
  Future<void> onReady() async{
    await watchOwnedStoreStarted();
    super.onReady();
  }

  @override
  void onClose() {
    _ownedStoreSub.cancel();
    _store.close();
    super.onClose();
  }
}
