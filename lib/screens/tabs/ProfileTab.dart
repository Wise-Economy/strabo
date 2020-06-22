import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../InitScreen.dart';
import '../../models/AppState.dart';
import '../../common/constants.dart';
import '../../common/widgets/progress.dart';

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
                backgroundImage: NetworkImage('${appState.currentUser?.photoUrl}'),
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
                    '${appState.currentUser?.displayName}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text('Email'),
              subtitle: Text('${appState.currentUser?.email}'),
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
                  appState.preferences.setBool(Constants.IS_LOGGED_IN, false);
                  Navigator.of(context).pop();
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
