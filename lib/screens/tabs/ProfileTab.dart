import 'package:finwise/common/constants.dart';
import 'package:finwise/screens/InitScreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/AppState.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('${appState.currentUser.photoUrl}'),
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
                    '${appState.currentUser.displayName}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text('Email'),
              subtitle: Text('${appState.currentUser.email}'),
            ),
            ListTile(
              onTap: () {
                appState.googleSignIn.disconnect().then((value) {
                  appState.preferences.setBool(Constants.IS_LOGGED_IN, false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InitScreen(),
                    ),
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
