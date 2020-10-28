import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertaladsod/application/store/store_view/store_view_cubit.dart';
import 'package:fluttertaladsod/presentation/core/components/progress_indicator.dart';

class BannerAppbar2 extends StatelessWidget {
  const BannerAppbar2();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreViewCubit, StoreViewState>(
      builder: (context, state) => SliverAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        expandedHeight: 350.0,
        pinned: true,
        title: Text(state.map(
              inital: (state) => '',
              loading: (state) => '',
              success: (state) => state.store.name.getOrCrash(),
              failure: (state) => 'error',
            ),),
        flexibleSpace: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FlexibleSpaceBar(
            background: state.map(
              inital: (state) => circularProgress(context),
              loading: (state) => circularProgress(context),
              success: (state) => Hero(
                tag: state.store.banner,
                child: CachedNetworkImage(
                  imageUrl: state.store.banner.url,
                  fit: BoxFit.cover,
                  placeholder: (context, str) => circularProgress(context),
                ),
              ),
              failure: (state) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}