import 'package:finwise/common/constants.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AppState.dart';
import '../screens/PasscodeScreen.dart';
import '../screens/RegisterScreen.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn;
  bool _isSignedIn = true;
  SharedPreferences _preferencesInstance;

  @override
  void initState() {
    super.initState();
    _googleSignIn = Provider.of<AppState>(context, listen: false).googleSignIn;
    _checkIfIsSignedIn();
  }

  _checkIfIsSignedIn() async {
    _preferencesInstance = await SharedPreferences.getInstance();
    Provider.of<AppState>(context, listen: false).preferences = _preferencesInstance;
    bool isLoggedIn = false;
    if (_preferencesInstance.containsKey(Constants.IS_LOGGED_IN)) {
      isLoggedIn = _preferencesInstance.getBool(Constants.IS_LOGGED_IN);
      isLoggedIn = await _googleSignIn.isSignedIn();
      if (isLoggedIn) {
        _currentUser = await _googleSignIn.signInSilently();
      }
    }
    setState(() {
      _isSignedIn = isLoggedIn;
    });

    gotoNextScreen();
  }

  _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        Provider.of<AppState>(context, listen: false).currentUser = _currentUser;
        _preferencesInstance.setBool(Constants.IS_LOGGED_IN, true);
        setState(() {
          _isSignedIn = true;
        });
      }

      gotoNextScreen();
    } catch (error) {
      print(error);
    }
  }

  gotoNextScreen() async {
    if (_isSignedIn) {
      //check if user already exists
      isExistingUser().then((value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasscodeScreen(isExistingUser: value),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(username: _currentUser.displayName, isExistingUser: value),
              ));
        }
      });
    }
  }

  // here goes network call with our server to check if user is existing or not
  Future<bool> isExistingUser() async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
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
                        'Wiseeco',
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
                      crossFadeState: _isSignedIn ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: Duration(milliseconds: 200),
                      firstChild: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlineButton(
                              highlightColor: Colors.transparent,
                              textColor: Colors.white,
                              highlightedBorderColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                              borderSide: BorderSide(color: Colors.white, width: 1),
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
