import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertaladsod/application/store/store_view/store_view_cubit.dart';
import 'package:fluttertaladsod/presentation/core/components/buttom_sheet.dart';
import 'package:fluttertaladsod/presentation/core/components/progress_indicator.dart';

class BannerAppbar extends StatelessWidget {
  const BannerAppbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _BannerAppBarDelegate(
        extent: 350,
      ),
    );
  }
}

class _BannerAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double extent;

  _BannerAppBarDelegate({this.extent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double diff = maxExtent - minExtent;
    final double fullyVisibleUntil = diff / 1.5;
    final cutTopOffset = shrinkOffset >= diff ? diff : shrinkOffset;
    final cutButtomOffset = cutTopOffset - fullyVisibleUntil <= 0
        ? 0
        : cutTopOffset - fullyVisibleUntil;
    final opacityOffSet =
        cutButtomOffset / (maxExtent - minExtent - fullyVisibleUntil);

    return BlocBuilder<StoreViewCubit, StoreViewState>(
      builder: (context, state) => ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            state.map(
              inital: (state) => circularProgress(context),
              loading: (state) => circularProgress(context),
              success: (state) => CachedNetworkImage(
                imageUrl: state.store.banner.url,
                fit: BoxFit.cover,
                placeholder: (context, str) => circularProgress(context),
              ),
              failure: (state) => Icon(Icons.error),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Colors.black54,
                    Colors.transparent,
                  ],
                  stops: const [0.1, 0.5],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
            Opacity(
              opacity: opacityOffSet,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: opacityOffSet,
                  child: Text(
                    state.map(
                      inital: (state) => '',
                      loading: (state) => '',
                      success: (state) => state.store.name.getOrCrash(),
                      failure: (state) => 'error',
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      BackButton(
                        color: Colors.white,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.white,
                        onPressed: () => showAppButtomSheet(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 106;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}