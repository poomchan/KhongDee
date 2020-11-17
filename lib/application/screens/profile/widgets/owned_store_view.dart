import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertaladsod/application/core/components/progress_indicator.dart';
import 'package:fluttertaladsod/application/screens/profile/bloc/store_own_watcher/owned_store_watcher_cubit.dart';
import 'package:fluttertaladsod/application/screens/profile/widgets/no_store_card.dart';
import 'package:fluttertaladsod/application/screens/store/widgets/store_card.dart';

class OwnedStoreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnedStoreWatcherCubit, OwnedStoreWatcherState>(
      builder: (context, state) => state.map(
        inital: (_) => null,
        loadInProgress: (state) => circularProgress(context),
        loadSuccess: (state) => StoreCard(
          store: state.store,
        ),
        loadFailure: (state) => state.f.map(
          noStore: (_) => NoStoreCard(),
          unexpected: (state) => Text('ERROR: unexpected failure : ${state.e}'),
          locationNotGranted: (_) => Text('ERROR: location not granted'),
          timeout: (_) => Text('Timeout'),
        ),
      ),
    );
  }
}