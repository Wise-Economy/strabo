import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/HomeScreen.dart';

class PasscodeScreen extends StatefulWidget {
  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String _pin = '';
  String confirmPin = '';
  final _pinLength = 6;
  String pinText;
  bool pinConfirming = false;
  bool inCorrectPin = false;
  bool newLogin = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (newLogin) {
        pinText = 'SETUP PIN';
      } else {
        pinText = 'ENTER PIN';
        _pin = '';
      }
    });
  }

  onChange(String number) async {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += number;
      });
    }
    if (_pin.length == _pinLength) {
      await Future.delayed(Duration(milliseconds: 100));
      if (newLogin) {
        if (pinConfirming) {
          if (confirmPin == _pin) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
          } else {
            setState(() {
              pinText = 'SETUP PIN';
              confirmPin = '';
              _pin = '';
              pinConfirming = false;
            });
          }
        } else {
          setState(() {
            pinText = 'CONFIRM PIN';
            confirmPin = _pin;
            _pin = '';
            pinConfirming = true;
          });
        }
      } else {
        if (_pin == '123456') {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
                 ),
              (route) => false);
        } else {
          setState(() {
            inCorrectPin = true;
            _pin = '';
          });
        }
      }
    }
  }

  onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
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
                      '$pinText',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
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
                                color: _pin.length <= index
                                    ? Colors.white
                                    : Colors.blueGrey,
                                border: Border.all(
                                    color: Colors.blueGrey, width: 2),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${inCorrectPin ? 'Incorrect Pin' : ''}',
                      style: TextStyle(color: Colors.red.shade300),
                    )
                  ],
                ),
              ),
            ),
            Wrap(
              children: List.generate(
                12,
                (index) =>
                    number(index == 9 ? 0 : index + 1, onChange, onDelete),
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
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
            right: BorderSide(color: Colors.blueGrey, width: 0.5),
          ),
        ),
        height: 100,
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
