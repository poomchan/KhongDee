import 'package:bloc/bloc.dart';
import 'package:fluttertaladsod/domain/auth/user.dart';
import 'package:fluttertaladsod/domain/location/i_location_repository.dart';
import 'package:fluttertaladsod/domain/store/i_store_repository.dart';
import 'package:fluttertaladsod/domain/store/store.dart';
import 'package:fluttertaladsod/domain/store/store_failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'owned_store_watcher_state.dart';
part 'owned_store_watcher_cubit.freezed.dart';

@injectable
class OwnedStoreWatcherCubit extends Cubit<OwnedStoreWatcherState> {
  final IStoreRepository _iStoreRepository;
  final ILocationRepository _iLocationRepository;

  OwnedStoreWatcherCubit(this._iStoreRepository, this._iLocationRepository)
      : super(_Initial());

  Future<void> watchOwnedStoreStarted({@required UserDomain user}) async {
    emit(OwnedStoreWatcherState.loadInProgress());

    final locationOption = await _iLocationRepository.getLocation();

    locationOption.fold(
      () => emit(OwnedStoreWatcherState.loadFailure(
          StoreFailure.locationNotGranted())),
      (location) {
        final stream = _iStoreRepository.watchOwnedStore(
          ownerId: user.id,
          location: location,
          user: user,
        );
        stream.listen(
          (storeOrF) {
            return storeOrF.fold(
                (f) => emit(OwnedStoreWatcherState.loadFailure(f)),
                (store) => emit(OwnedStoreWatcherState.loadSuccess(store)));
          },
        );
      },
    );
  }
}