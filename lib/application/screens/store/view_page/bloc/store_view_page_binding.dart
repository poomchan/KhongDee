
import 'package:fluttertaladsod/application/screens/store/setting/bloc/store_setting_bloc.dart';
import 'package:get/get.dart';
import 'store_view_bloc.dart';

class StoreViewPB extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoreViewBloc());
    Get.lazyPut(() => StoreSettingBloc());
  }

}