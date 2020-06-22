import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AppState.dart';
import '../common/constants.dart';
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
      print('isLoggedIn: $isLoggedIn');
      bool isGSignIn = await _googleSignIn.isSignedIn();
      print('isGSignIn: $isGSignIn');
      if (isLoggedIn && isGSignIn) {
        _currentUser = await _googleSignIn.signInSilently();
        Provider.of<AppState>(context, listen: false).currentUser = _currentUser;
      } else {
        if (isGSignIn) {
          await _googleSignIn.disconnect();
        }
        isLoggedIn = false;
      }
    }
    print('isLoggedIn: $isLoggedIn');
    setState(() {
      _isSignedIn = isLoggedIn;
    });

    gotoNextScreen();
  }

  _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      _currentUser.authentication.then((value) => print('Access Token: ${value.accessToken}'));
      if (_currentUser != null) {
        if (isExistingUser()) {
          _preferencesInstance.setBool(Constants.IS_LOGGED_IN, true);
        }
        Provider.of<AppState>(context, listen: false).currentUser = _currentUser;
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
      if (isExistingUser()) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasscodeScreen(isExistingUser: true),
          ),
        );
      } else {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(username: _currentUser.displayName, isExistingUser: false),
          ),
        );
        if (!result) {
          await _googleSignIn.disconnect();
          setState(() {
            _isSignedIn = result;
          });
        }
      }
    }
  }

  // here goes network call with our server to check if user is existing or not
  bool isExistingUser() {
    if (_preferencesInstance.containsKey(Constants.IS_EXISTING_USER)) {
      return _preferencesInstance.getBool(Constants.IS_EXISTING_USER);
    }
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
              Container(
                height: 80,
                width: 300,
                child: AnimatedCrossFade(
                  sizeCurve: Curves.easeInOutBack,
                  crossFadeState: _isSignedIn ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                  firstChild: Center(
                    key: ValueKey('1'),
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
                    key: ValueKey('2'),
                    child: CircularProgressIndicator(),
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
