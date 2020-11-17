import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertaladsod/application/core/components/image_network.dart';
import 'package:fluttertaladsod/application/core/components/progress_indicator.dart';
import 'package:fluttertaladsod/application/global_bloc/auth/watcher/auth_watcher_cubit.dart';
import 'package:fluttertaladsod/application/routes/router.gr.dart';


class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthWatcherCubit, AuthWatcherState>(
      builder: (context, state) => GestureDetector(
        onTap: () => state.maybeMap(
            unAuthenticated: (_) =>
                ExtendedNavigator.of(context).pushSignInSplash(),
            authenticated: (state) => ExtendedNavigator.of(context).push(
                  Routes.profilePage,
                  arguments: ProfilePageArguments(user: state.user),
                ),
            orElse: () => null),
        child: Hero(
          tag: state.maybeMap(
              authenticated: (state) => state.user.photoURL, orElse: () => ""),
          child: CircleAvatar(
            backgroundColor: state.maybeMap(
                authenticated: (_) => Colors.transparent,
                orElse: () => Colors.teal),
            radius: 30.0,
            backgroundImage: state.maybeMap(
                authenticated: (state) => imageNetwork(state.user.photoURL),
                orElse: () => null),
            child: state.maybeMap(
              authenticated: (_) => null,
              loading: (_) => circularProgress(context),
              orElse: () => Icon(Icons.supervised_user_circle),
            ),
          ),
        ),
      ),
    );
  }
}