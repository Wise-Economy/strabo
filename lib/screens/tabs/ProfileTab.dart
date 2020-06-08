import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/AppData.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount _currentuser =
        Provider.of<AppData>(context, listen: false).currentUser;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('${_currentuser.photoUrl}'),
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
                    '${_currentuser.displayName}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text('Email'),
              subtitle: Text('${_currentuser.email}'),
            )
          ],
        ),
      ),
    );
  }
}
