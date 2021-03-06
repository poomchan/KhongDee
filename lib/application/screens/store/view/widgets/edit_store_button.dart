// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:fluttertaladsod/application/routes/router.dart';
import 'package:fluttertaladsod/application/screens/store/view/bloc/store_view_bloc.dart';

class EditStoreButton extends StatelessWidget {
  const EditStoreButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Get.find<StoreViewBloc>();
    return OutlineButton(
      onPressed: () => Get.toNamed(Routes.storeForm, arguments: some(bloc.store)),
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: Text('Edit Store Appearance'),
    );
  }
}
