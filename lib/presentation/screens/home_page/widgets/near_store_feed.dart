import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertaladsod/application/home/store_feed/nearby/store_near_cubit.dart';
import 'package:fluttertaladsod/application/location/location_cubit.dart';
import 'package:fluttertaladsod/domain/store/store.dart';
import 'package:fluttertaladsod/presentation/core/components/progress_indicator.dart';
import 'package:fluttertaladsod/presentation/screens/store/widgets/store_card2.dart';

class NearStoreFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stores close to you',
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(height: 10.0),
        Divider(height: 0.0),
        BlocBuilder<StoreNearCubit, StoreNearState>(
          builder: (context, state) => state.maybeMap(
            loading: (state) => linearProgress(context),
            orElse: () => const SizedBox(height: 10.0 + 4.0),
          ),
        ),
        BlocBuilder<StoreNearCubit, StoreNearState>(
          builder: (context, state) => state.map(
            inital: (state) => circularProgress(context),
            loading: (state) =>
                _buildFeed(context, storeList: state.previousStoreList),
            failure: (state) => Center(
              child: state.f.map(
                noStore: (_) => Text('No store nearby, try adding radius'),
                unexpected: (state) => Text('Unexpected Error \n For nerds: ${state.e}'),
                locationNotGranted: (_) => TextButton(
                  onPressed: () =>
                      context.bloc<LocationCubit>().getUserLocation(),
                  child: Text('Enable Location'),
                ),
                timeout: (_) => Column(
                  children: [
                    Text('Timeout'),
                    TextButton(
                      onPressed: () =>
                          context.bloc<StoreNearCubit>().watchNearbyStore(),
                      child: Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
            loaded: (state) => _buildFeed(context, storeList: state.storeList),
          ),
        ),
        ButtonBar(
          children: [
            BlocBuilder<StoreNearCubit, StoreNearState>(
              builder: (context, state) => state.maybeMap(
                loaded: (state) => Text('Searched in ${state.rad} km'),
                orElse: () => const SizedBox(height: 10.0 + 4.0),
              ),
            ),
            RaisedButton(
              onPressed: () =>
                  context.bloc<StoreNearCubit>().requestMoreRadius(),
              child: Text('Add Radius'),
            ),
            RaisedButton(
              onPressed: () => context.bloc<StoreNearCubit>().drainRadius(),
              child: Text('Drain Radius'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeed(BuildContext context, {@required List<Store> storeList}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: storeList.length,
      itemBuilder: (context, index) => _buildStoreCard(storeList[index]),
    );
  }

  Widget _buildStoreCard(Store store) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StoreCard2(store: store),
    );
  }
}
