import 'package:flutter/material.dart';
import 'package:fluttertaladsod/application/bloc/auth/auth_bloc.dart';
import 'package:fluttertaladsod/application/bloc/core/view_widget.dart';
import 'package:fluttertaladsod/application/routes/router.dart';
import 'package:fluttertaladsod/application/screens/profile/setting/bloc/blocked_store_bloc.dart';
import 'package:fluttertaladsod/application/screens/profile/setting/bloc/profile_setting_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

class ProfileSettingPage extends ViewWidget<ProfileSettingBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          SettingsList(
            backgroundColor: Theme.of(context).backgroundColor,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            sections: [
              SettingsSection(
                title: 'Section',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onTap: () => Get.toNamed(Routes.languageSettingPage),
                  ),
                  SettingsTile(
                    title: 'Blocked store',
                    subtitle: '',
                    leading: Icon(Icons.block),
                    onTap: () => Get.toNamed(Routes.blockedStoreSettingPage),
                  ),
                ],
              ),
              SettingsSection(
                title: 'Policies',
                tiles: [
                  SettingsTile(
                    title: 'Privacy Policy',
                    leading: Icon(Icons.privacy_tip),
                    onTap: () {},
                  ),
                  SettingsTile(
                    title: 'Terms of Use',
                    leading: Icon(Icons.policy),
                    onTap: () {},
                  ),
                  SettingsTile(
                    title: 'About the Application',
                    leading: Icon(Icons.info),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Kong Dee',
                      applicationVersion: '0.0.1',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () => Get.find<AuthBloc>().signOut(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Sign Out'),
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(FontAwesomeIcons.signOutAlt),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
