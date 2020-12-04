import 'package:flutter/material.dart';
import 'package:fluttertaladsod/application/screens/home_page/widgets/near_store_feed.dart';
import 'package:fluttertaladsod/application/screens/home_page/widgets/profile_avatar.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          ProfileAvatar(),
          const SizedBox(width: 30),
        ],
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                NearStoreFeed(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

