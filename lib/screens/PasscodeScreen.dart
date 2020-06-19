import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    _isNewUser = widget.isExistingUser ?? false;
    setState(() {
      if (_isNewUser) {
        _pinText = 'ENTER PIN';
      } else {
        _pinText = 'SETUP PIN';
      }
    });
  }

  onKeyPressHandler(String number) async {
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
            _preferencesInstance.setBool(Constants.IS_EXISTING_USER, true);
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
              _inCorrectPin = true;
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

  onDeleteKeyHandler() {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_pinText',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 15),
                  Text(
                    '${_inCorrectPin ? 'Incorrect Pin' : ''}',
                    style: TextStyle(color: Colors.red.shade300),
                  )
                ],
              ),
            ),
//            ConstrainedBox(
//              constraints: BoxConstraints(maxWidth: 360),
//              child: keypad(onKeyPressHandler, onDeleteKeyHandler),
//            ),
            Wrap(
              children: List.generate(
                12,
                (index) => number(index == 9 ? 0 : index + 1, onKeyPressHandler, onDeleteKeyHandler),
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

Widget keypad(onKeyPressHandler, onDeleteKeyHandler) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: ['1', '2', '3'].map((e) => key(e, onKeyPressHandler)).toList()),
        TableRow(children: ['4', '5', '6'].map((e) => key(e, onKeyPressHandler)).toList()),
        TableRow(children: ['7', '8', '9'].map((e) => key(e, onKeyPressHandler)).toList()),
        TableRow(children: [
          SizedBox.shrink(),
          key('0', onKeyPressHandler),
          delete(onDeleteKeyHandler),
        ]),
      ],
    ),
  );
}

Widget delete(onDeleteKeyHandler) {
  return Center(
    child: InkWell(
      onTap: onDeleteKeyHandler,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        child: SvgPicture.asset('assets/feather/delete.svg'),
      ),
    ),
  );
}

Widget key(String key, onPress) {
  return Center(
    child: InkWell(
      onTap: () {
        onPress(key);
      },
      borderRadius: BorderRadius.circular(30),
      highlightColor: Colors.transparent,
      child: Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        child: Text(
          '$key',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28),
        ),
      ),
    ),
  );
}
