import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../InitScreen.dart';
import '../../models/AppState.dart';
import '../../models/User.dart';
import '../../common/constants.dart';
import '../../common/widgets/progress.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    User _currentUser = appState.user;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('${_currentUser?.profilePhoto}'),
                minRadius: 25,
                maxRadius: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${_currentUser?.fullName}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text('Email'),
              subtitle: Text('${_currentUser?.email}'),
            ),
            ListTile(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return progress();
                  },
                );
                appState.googleSignIn.disconnect().then((value) {
                  appState.preferences?.setBool(Constants.IS_LOGGED_IN, false);
                  appState.preferences?.setBool(Constants.IS_PIN_SET, false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitScreen(),
                    ),
                    (route) => false,
                  );
                });
              },
              title: Text(
                'Log out',
              ),
            )
          ],
        ),
      ),
    );
  }
}
