import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AppState.dart';
import '../models/GUser.dart';
import '../models/User.dart';
import '../common/constants.dart';
import '../common/widgets/progress.dart';
import '../screens/PasscodeScreen.dart';
import '../screens/RegisterScreen.dart';
import '../models/GConnect.dart';
import '../api/API.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn;
  bool _showProgress = true;
  SharedPreferences _prefsInstance;
  OurServer _ourServer;

  @override
  void initState() {
    super.initState();
    _googleSignIn = Provider.of<AppState>(context, listen: false).googleSignIn;
    _ourServer = Provider.of<OurServer>(context, listen: false);
    _init();
  }

  @override
  void dispose() {
    _prefsInstance = null;
    _currentUser = null;
    _googleSignIn = null;
    super.dispose();
  }

  void _checkIfIsSignedIn() {
    bool isLoggedIn = _prefsInstance.getBool(Constants.IS_LOGGED_IN);
    if (isLoggedIn ?? false) {
      User user = User.fromRawJson(_prefsInstance.getString(Constants.USER_INFO));
      Provider.of<AppState>(context, listen: false).user = user;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PasscodeScreen(isExistingUser: true)),
      );
    }
  }

  _init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    Provider.of<AppState>(context, listen: false).preferences = _prefsInstance;
    setState(() {
      _showProgress = false;
    });
    _checkIfIsSignedIn();
  }

  _handleSignIn() async {
    try {
      setState(() {
        _showProgress = true;
      });
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.disconnect();
      }
      setState(() {
        _showProgress = false;
      });
      _currentUser = await _googleSignIn?.signIn();
      if (_currentUser != null) {
        Provider.of<AppState>(context, listen: false).currentUser = _currentUser;
        GoogleSignInAuthentication _googleSignInAuthentication = await _currentUser?.authentication;
        String accessToken = _googleSignInAuthentication?.accessToken;
        GUser gUser = GUser(
            googleId: _currentUser.id,
            fullName: _currentUser.displayName,
            profilePhoto: _currentUser.photoUrl,
            email: _currentUser.email,
            googleSecretToken: accessToken);

        setState(() {
          _showProgress = true;
        });
        http.Response response = await _ourServer?.googleConnect(gUser);
        if (response?.statusCode == 200) {
          String sessionId = response?.headers['set-cookie'].split(";")[4].split(",")[1].split('=')[1];
          _prefsInstance.setString(Constants.SESSION_ID, sessionId);
          GConnect gConnect = GConnect.fromRawJson(response?.body);
          if (gConnect.isNewUser) {
            final refresh = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen(user: gConnect.user, isExistingUser: false)),
            );
            if (!refresh) {
              await _googleSignIn?.disconnect();
            }
            setState(() {
              _showProgress = false;
            });
          } else {
            setState(() {
              _showProgress = false;
            });
            Provider.of<AppState>(context, listen: false).user = gConnect.user;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasscodeScreen(isExistingUser: true)),
            );
          }
        } else {
          setState(() {
            _showProgress = false;
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'STRABO',
                        style: TextStyle(fontSize: 35.0, color: Colors.white),
                      ),
                      Text(
                        'Personal finance manager',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 80,
                width: 320,
                child: AnimatedCrossFade(
                  sizeCurve: Curves.easeInOutBack,
                  crossFadeState: _showProgress ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                              SizedBox(width: 10),
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
