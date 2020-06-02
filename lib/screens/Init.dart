import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/passcode.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'profile',
    'https://www.googleapis.com/auth/userinfo.profile'
  ],
);

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  GoogleSignInAccount _currentUser;
  bool isSignedIn = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsSignedIn();
  }

  _checkIfIsSignedIn() async {
    await Future.delayed(Duration(seconds: 2));
    bool result = await _googleSignIn.isSignedIn();
    setState(() {
      isSignedIn = result;
    });
    gotoPinScreen();
  }

  _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        setState(() {
          isSignedIn = true;
        });
      }
      await Future.delayed(Duration(seconds: 2));
      gotoPinScreen();
      print(_currentUser);
    } catch (error) {
      print(error);
    }
  }

  gotoPinScreen() {
    if (isSignedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasscodeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f304e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Finwise',
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                      Text(
                        'Personal finance manager',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  height: 80,
                  width: 300,
                  child: Center(
                    child: AnimatedCrossFade(
                      crossFadeState: isSignedIn
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 200),
                      firstChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                            highlightColor: Colors.transparent,
                            textColor: Colors.white,
                            highlightedBorderColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/brand/google.svg',
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Connect via Google',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: _handleSignIn),
                      ),
                      secondChild: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
