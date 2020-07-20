import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';
import '../models/AppState.dart';
import '../models/User.dart';
import '../screens/HomeScreen.dart';

class PasscodeScreen extends StatefulWidget {
  final isExistingUser;

  PasscodeScreen({@required this.isExistingUser});

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _pinText = '';
  String _confirmPin = '';
  bool _pinConfirming = false;
  bool _inCorrectPin = false;
  bool _isPinSet = false;
  SharedPreferences _preferencesInstance;
  TextEditingController _pinController = TextEditingController();
  User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Provider.of<AppState>(context, listen: false).user;
    _preferencesInstance = Provider.of<AppState>(context, listen: false).preferences;
    bool value = _preferencesInstance?.getBool(Constants.IS_PIN_SET);
    if (value ?? false) {
      _isPinSet = value;
    }
    if (_isPinSet) {
      _pinText = 'ENTER PIN';
    } else {
      _pinText = 'SETUP PIN';
    }
  }

  _onSubmit(String pin) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (_isPinSet) {
      String savedPIN = "";
      if (_preferencesInstance?.containsKey(Constants.LOCAL_PIN) ?? false) {
        savedPIN = _preferencesInstance?.getString(Constants.LOCAL_PIN);
      }
      if (pin == savedPIN) {
        _preferencesInstance.setBool(Constants.IS_LOGGED_IN, true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      } else {
        setState(() {
          _inCorrectPin = true;
          _pinController.clear();
        });
      }
    } else {
      if (_pinConfirming) {
        if (_confirmPin == pin) {
          _preferencesInstance?.setBool(Constants.IS_LOGGED_IN, true);
          _preferencesInstance?.setString(Constants.LOCAL_PIN, pin);
          _preferencesInstance?.setBool(Constants.IS_PIN_SET, true);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
        } else {
          setState(() {
            _pinText = 'SETUP PIN';
            _confirmPin = '';
            _pinController.clear();
            _pinConfirming = false;
            _inCorrectPin = true;
          });
        }
      } else {
        setState(() {
          _pinText = 'CONFIRM PIN';
          _confirmPin = pin;
          _pinController.clear();
          _pinConfirming = true;
        });
      }
    }
  }

  _onChangedHandler(String pin) {
    if (pin.isNotEmpty && pin.length == 6) {
      _onSubmit(pin);
    }
  }

  _onForgotPinHandler() async {
    bool reset = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure, you want to reset it again ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO,THANKS'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('RESET'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (reset) {
      setState(() {
        _isPinSet = false;
        _inCorrectPin = false;
        if (_isPinSet) {
          _pinText = 'ENTER PIN';
        } else {
          _pinText = 'SETUP PIN';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isPinSet
                  ? _currentUser?.profilePhoto == null
                      ? SvgPicture.asset(
                          'assets/feather/user.svg',
                          height: 50,
                          width: 50,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(_currentUser?.profilePhoto),
                          radius: 30,
                        )
                  : SizedBox.shrink(),
              !_isPinSet
                  ? Text(
                      'Welcome',
                      style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              Text(
                '${_currentUser?.fullName ?? ''}',
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 10),
              Text(
                '$_pinText',
                style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                width: 300,
                child: TextField(
                  controller: _pinController,
                  autofocus: true,
                  enableInteractiveSelection: true,
                  maxLength: 6,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: _onChangedHandler,
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, letterSpacing: 10),
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: "",
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(8.0),
                    hintStyle: TextStyle(color: Color.fromRGBO(199, 202, 216, 1), fontSize: 26.0),
                    filled: true,
                    fillColor: Color.fromRGBO(241, 245, 251, 1),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${_inCorrectPin ? '${_isPinSet ? 'Incorrect PIN Try again' : 'Incorrect PIN Setup again'}' : ''}',
                style: TextStyle(color: Colors.red.shade300),
              ),
              SizedBox(height: 5),
              _isPinSet
                  ? _inCorrectPin
                      ? FlatButton(
                          onPressed: _onForgotPinHandler,
                          child: Text(
                            'Forgot PIN',
                            style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                          ),
                        )
                      : SizedBox.shrink()
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
