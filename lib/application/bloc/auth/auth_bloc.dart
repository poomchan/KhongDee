// Dart imports:
import 'dart:async';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:fluttertaladsod/application/bloc/core/simple_progress_setter.dart';
import 'package:fluttertaladsod/application/routes/router.dart';
import 'package:fluttertaladsod/domain/auth/auth_failure.dart';
import 'package:fluttertaladsod/domain/auth/i_auth_facade.dart';
import 'package:fluttertaladsod/domain/user/user.dart';

class AuthBloc extends GetxController with SimepleProgressSetter<AuthFailure> {
  IAuthFacade get _iAuthFacade => Get.find<IAuthFacade>();

  final _user = Rx<UserDomain>();
  Rx<UserDomain> get rxUser => _user;
  UserDomain get user => _user.value;
  bool get isAuth => _iAuthFacade.isAuthenticated();
  RxBool get rxIsAuth => RxBool(false)..bindStream(_user.map((user) => user != null));

  StreamSubscription _userSub;

  void checkAuthStatus() {
    if (isAuth) {
      watchUser();
    } else {
      _user.value = null;
    }
  }

  Future<void> watchUser() async {
    setLoading();
    final userOrFailureStream = _iAuthFacade.watchSignedInUser();
    _userSub = userOrFailureStream.listen((userOrFailure) {
      return userOrFailure.fold(
        (f) {
          print('AuthBloc: not auth');
          _user.value = null;
          setFailure(f);
        },
        (user) {
          print('AuthBloc : auth');
          _user.value = user;
          setLoaded();
        },
      );
    });
  }

  Future<void> signOut() async {
    await _iAuthFacade.signOut();
    navigator.popUntil((route) => route.settings.name == Routes.homePage);
  }

  @override
  Future<void> onReady() async {
    checkAuthStatus();
    super.onReady();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _user?.close();
    super.onClose();
  }
}
