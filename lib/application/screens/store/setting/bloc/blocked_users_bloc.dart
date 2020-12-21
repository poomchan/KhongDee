import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertaladsod/application/bloc/core/simple_progress_setter.dart';
import 'package:fluttertaladsod/application/core/haptic_feedback.dart';
import 'package:fluttertaladsod/application/screens/store/setting/bloc/store_setting_bloc.dart';
import 'package:fluttertaladsod/application/screens/store/setting/widgets/dialogs.dart';
import 'package:fluttertaladsod/application/screens/store/view_page/bloc/store_view_bloc.dart';
import 'package:fluttertaladsod/domain/auth/user/i_user_repository.dart';
import 'package:fluttertaladsod/domain/auth/user/user.dart';
import 'package:fluttertaladsod/domain/auth/user/user_failure.dart';
import 'package:fluttertaladsod/domain/core/value_objects.dart';
import 'package:fluttertaladsod/domain/store/i_store_repository.dart';
import 'package:fluttertaladsod/domain/store/store_failures.dart';
import 'package:get/get.dart';

class BlockedUsersSettingBloc extends GetxController
    with SimepleProgressSetter<UserFailure> {
  final IUserRepository _iUserRepository = Get.find();
  final StoreSettingBloc _storeSettingBloc = Get.find();
  final StoreViewBloc _storeViewBloc = Get.find();
  final IStoreRepository _iStoreRepository = Get.find();

  Map<String, bool> get map => _storeSettingBloc.store.blockedUsers;

  UserDomain userOnFocus;
  bool get isBlocked => map[userOnFocus.id.getOrCrash()] == true;

  bool isThisUserBlocked(UserDomain u) => map[u.id.getOrCrash()] == true;

  List<UserDomain> blockedUserList = [];

  Future<void> getBlockedUsers() async {
    bool isFailed = false;
    for (final uid in map.keys) {
      if (map[uid] == true) {
        final fOrUser =
            await _iUserRepository.getUser(UniqueId.fromUniqueString(uid));
        fOrUser.fold(
          (f) {
            isFailed = true;
            updateWithFailure(f);
          },
          (user) => blockedUserList.add(user),
        );
      }
    }
    if (!isFailed) updateWithLoaded();
  }

  void onUserTapped(UserDomain user) {
    userOnFocus = user;
    showCupertinoModalPopup(
      context: Get.context,
      builder: (_) => buildAvatarActionSheet(),
    );
  }

  Future<void> onBlockUserTapped() async {
    Get.back();
    updateWithLoading();
    Get.dialog(
      buildBlockingDialog(),
      barrierDismissible: false,
    );
    final fOrUnit = await _blockUser();
    fOrUnit.fold(
      (f) => updateWithFailure(UserFailure.unexpected(f)),
      (unit) async {
        Get.back();
        updateWithLoaded();
        await doubleHapticFeedback();
      },
    );
  }

  Future<Either<StoreFailure, Unit>> _blockUser() async {
    final store = _storeViewBloc.store;
    return _iStoreRepository.update(
      store.copyWith(
        blockedUsers: store.blockedUsers
          ..addEntries(
            [MapEntry(userOnFocus.id.getOrCrash(), !isBlocked)],
          ),
      ),
    );
  }

  @override
  void onClose() {
    blockedUserList = null;
    super.onClose();
  }

  @override
  Future<void> onReady() async {
    updateWithLoading();
    await getBlockedUsers();
    super.onReady();
  }
}
