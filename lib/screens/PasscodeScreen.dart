import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  String _confirmPin = '';
  String _pinText;
  bool _pinConfirming = false;
  bool _inCorrectPin = false;
  bool _isExistingUser;
  SharedPreferences _preferencesInstance;
  TextEditingController _pinController = TextEditingController();
  User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = Provider.of<AppState>(context, listen: false).user;
    _preferencesInstance = Provider.of<AppState>(context, listen: false).preferences;
    _isExistingUser = widget.isExistingUser ?? false;
    setState(() {
      if (_isExistingUser) {
        _pinText = 'ENTER PIN';
      } else {
        _pinText = 'SETUP PIN';
      }
    });
  }

  onSubmit(String pin) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (_isExistingUser) {
      String savedPIN;
      if (_preferencesInstance.containsKey(Constants.LOCAL_PIN)) {
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
          _preferencesInstance?.setBool(Constants.IS_EXISTING_USER, true);
          _preferencesInstance?.setString(Constants.LOCAL_PIN, pin);
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

  onChangedHandler(String pin) {
    if (pin.isNotEmpty && pin.length == 6) {
      onSubmit(pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isExistingUser
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser?.profilePhoto),
                    radius: 30,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            Text(
              '${_currentUser?.fullName}',
              style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              '$_pinText',
              style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pinController,
              autofocus: true,
              enableInteractiveSelection: true,
              maxLength: 6,
              obscureText: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: onChangedHandler,
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
            SizedBox(height: 5),
            Text(
              '${_inCorrectPin ? '${_isExistingUser ? 'Incorrect PIN Try again' : 'Incorrect PIN Setup again'}' : ''}',
              style: TextStyle(color: Colors.red.shade300),
            ),
            SizedBox(height: 5),
            _isExistingUser
                ? Text(
                    '${_inCorrectPin ? 'Forgot PIN' : ''}',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
