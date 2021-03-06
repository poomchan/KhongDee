// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:fluttertaladsod/application/bloc/core/view_widget.dart';
import 'package:fluttertaladsod/application/core/components/progress_indicator.dart';
import 'package:fluttertaladsod/application/routes/router.dart';
import 'package:fluttertaladsod/application/screens/store/view/widgets/banner_appbar2.dart';
import 'package:fluttertaladsod/application/screens/store/view/widgets/image_view.dart';
import 'package:fluttertaladsod/application/screens/store/view/widgets/menu_view.dart';
import 'package:fluttertaladsod/application/screens/store/view/widgets/name_view.dart';
import 'package:fluttertaladsod/domain/core/value_objects.dart';
import 'bloc/store_view_bloc.dart';
import 'widgets/console.dart';

class StoreViewPage2 extends ViewWidget<StoreViewBloc> {
  final UniqueId storeId;

  const StoreViewPage2({Key key, @required this.storeId})
      : assert(storeId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StoreViewBloc>(
        builder: (bloc) => bloc.progress.when(
          inital: () => circularProgress(context),
          loading: () => circularProgress(context),
          loaded: () => _buildStoreView(context),
          failure: () => _buildErrorWidget(context),
        ),
      ),
    );
  }

  Widget _buildStoreView(BuildContext context) {
    final screenWidth = Get.width;
    return Obx(
      () => ColorFiltered(
        colorFilter: bloc.store.prefs.isOpen
            ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
            : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
        child: Scaffold(
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FloatingActionButton(
              //   heroTag: null,
              //   backgroundColor: Colors.blueAccent,
              //   shape: const StadiumBorder(),
              //   onPressed: () => print('linking'),
              //   child: const Icon(Icons.thumb_up),
              // ),
              const SizedBox(width: 10.0),
              FloatingActionButton.extended(
                heroTag: null,
                shape: const StadiumBorder(),
                onPressed: () => Get.toNamed(Routes.chatPage),
                backgroundColor: Get.theme.primaryColor,
                label: Row(
                  children: [
                    Text(
                      'chat',
                      style: Get.textTheme.button.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.chat, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              const BannerAppbar2(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: screenWidth,
                      child: Column(
                        children: const [
                          Console(),
                          SizedBox(height: 10.0),
                          NameView(),
                          SizedBox(height: 10.0),
                          MenuView(),
                          SizedBox(height: 10.0),
                          ImageView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return GetBuilder<StoreViewBloc>(
      builder: (bloc) => Center(
        child: Column(
          children: [
            Icon(Icons.error),
            bloc.failure.when(
              noStore: () => Text('Error 404: No store found'),
              unexpected: (err) => Text('Unexpected Error: $err'),
              locationNotGranted: () => Text('Please enable location'),
              timeout: () => Text('Time out, try reload again'),
            ),
          ],
        ),
      ),
    );
  }
}
