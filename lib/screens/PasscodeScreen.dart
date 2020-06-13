import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';
import '../models/AppState.dart';
import '../screens/HomeScreen.dart';

class PasscodeScreen extends StatefulWidget {
  final isExistingUser;

  PasscodeScreen({@required this.isExistingUser});

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _actualPin = '';

  String _confirmPin = '';
  final _pinLength = 6;
  String _pinText;
  bool _pinConfirming = false;
  bool _inCorrectPin = false;
  bool _isNewUser;

  SharedPreferences _preferencesInstance;

  @override
  void initState() {
    super.initState();
    _preferencesInstance = Provider.of<AppState>(context, listen: false).preferences;
    _isNewUser = widget.isExistingUser;
    setState(() {
      if (_isNewUser) {
        _pinText = 'ENTER PIN';
      } else {
        _pinText = 'SETUP PIN';
      }
    });
  }

  onChange(String number) async {
    if (_actualPin.length < _pinLength) {
      setState(() {
        _actualPin += number;
      });
    }
    if (_actualPin.length == _pinLength) {
      await Future.delayed(Duration(milliseconds: 100));
      if (_isNewUser) {
        if (_actualPin == '123456') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
        } else {
          setState(() {
            _inCorrectPin = true;
            _actualPin = '';
          });
        }
      } else {
        if (_pinConfirming) {
          if (_confirmPin == _actualPin) {
            _preferencesInstance.setBool(Constants.IS_LOGGED_IN, true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
            print('$_actualPin PIN SETUP SUCCESS');
          } else {
            setState(() {
              _pinText = 'SETUP PIN';
              _confirmPin = '';
              _actualPin = '';
              _pinConfirming = false;
            });
          }
        } else {
          setState(() {
            _pinText = 'CONFIRM PIN';
            _confirmPin = _actualPin;
            _actualPin = '';
            _pinConfirming = true;
          });
        }
      }
    }
  }

  onDelete() {
    if (_actualPin.isNotEmpty) {
      setState(() {
        _actualPin = _actualPin.substring(0, _actualPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$_pinText',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        _pinLength,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: _actualPin.length <= index ? Colors.white : Colors.blueGrey,
                                border: Border.all(color: Colors.blueGrey, width: 1),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${_inCorrectPin ? 'Incorrect Pin' : ''}',
                      style: TextStyle(color: Colors.red.shade300),
                    )
                  ],
                ),
              ),
            ),
            Wrap(
              children: List.generate(
                12,
                (index) => number(index == 9 ? 0 : index + 1, onChange, onDelete),
              ),
              crossAxisAlignment: WrapCrossAlignment.center,
            )
          ],
        ),
      ),
    );
  }
}

Widget number(int number, onChange, onDelete) {
  return FractionallySizedBox(
    widthFactor: 0.3333,
    child: InkWell(
      onTap: () {
        if (number <= 10) {
          onChange(number.toString());
        } else if (number == 12) {
          onDelete();
        }
      },
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
            right: BorderSide(color: Colors.blueGrey, width: 0.5),
          ),
        ),
        height: 100,
        width: 100,
        child: Center(
          child: number != 12
              ? Text(
                  '${number == 11 ? '' : number}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                )
              : SvgPicture.asset('assets/feather/delete.svg'),
        ),
      ),
    ),
  );
}
