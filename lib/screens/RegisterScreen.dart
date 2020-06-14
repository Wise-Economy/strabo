import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/PasscodeScreen.dart';
import '../models/AppState.dart';

class RegisterScreen extends StatefulWidget {
  final String username;
  final bool isExistingUser;

  RegisterScreen({this.username, this.isExistingUser});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dobController = TextEditingController();
  String _buttonLabel = "Continue";
  bool _enabled = true;

  String _userName;
  String _userDOB;
  String _userCity;
  String _userResidence;
  String _userCitizenship;

  @override
  void initState() {
    super.initState();
    _userName = widget.username;
  }

  _onSaveCountry(CountryType type, String value) {
    if (type == CountryType.Residense) {
      _userResidence = value;
    } else {
      _userCitizenship = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Register',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                autofocus: false,
                                enableInteractiveSelection: true,
                                maxLength: 100,
                                initialValue: _userName,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  isDense: true,
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(12.0),
                                  hintText: 'Name',
                                  hintStyle: TextStyle(color: Color.fromRGBO(199, 202, 216, 1), fontSize: 16.0),
                                  filled: true,
                                  fillColor: Color.fromRGBO(241, 245, 251, 1),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Name can't be empty";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userName = value;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                autofocus: false,
                                controller: _dobController,
                                enableInteractiveSelection: true,
                                keyboardType: TextInputType.datetime,
                                maxLength: 10,
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  isDense: true,
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(12.0),
                                  hintText: 'DOB(DD/MM/YYYY)',
                                  hintStyle: TextStyle(color: Color.fromRGBO(199, 202, 216, 1), fontSize: 16.0),
                                  filled: true,
                                  fillColor: Color.fromRGBO(241, 245, 251, 1),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "DOB can't be empty";
                                  }
                                  if (value.split('/').length != 3) return 'Invalid Date';
                                  return null;
                                },
                                onSaved: (value) {
                                  _userDOB = value;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                autofocus: false,
                                enableInteractiveSelection: true,
                                maxLength: 100,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  isDense: true,
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(12.0),
                                  hintText: 'City',
                                  hintStyle: TextStyle(color: Color.fromRGBO(199, 202, 216, 1), fontSize: 16.0),
                                  filled: true,
                                  fillColor: Color.fromRGBO(241, 245, 251, 1),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                      borderSide: BorderSide(color: Colors.transparent)),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "City can't be empty";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userCity = value;
                                },
                              ),
                              const SizedBox(height: 15),
                              CountryOptions(type: CountryType.Residense, onSave: _onSaveCountry),
                              const SizedBox(height: 15),
                              CountryOptions(type: CountryType.Citizenship, onSave: _onSaveCountry),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(30.0),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    highlightElevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print('$_userName,$_userDOB,$_userCity,$_userResidence,$_userCitizenship');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasscodeScreen(
                                isExistingUser: widget.isExistingUser,
                              ),
                            ),
                            (route) => false);
                      }
                    },
                    child: Text(
                      '$_buttonLabel',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    textColor: Colors.white,
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

enum CountryType { Residense, Citizenship }

class CountryOptions extends StatefulWidget {
  final CountryType type;
  final onSave;

  CountryOptions({this.type, this.onSave});

  @override
  _CountryOptionsState createState() => _CountryOptionsState();
}

class _CountryOptionsState extends State<CountryOptions> {
  String dropdownValue;
  final _countries = ["INDIA", "GERMANY", "UK"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: dropdownValue,
      items: _countries.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      hint: Text(
        'Country of ${widget.type == CountryType.Residense ? 'residense' : 'citizenship'}',
        style: TextStyle(
          color: Color.fromRGBO(199, 202, 216, 1),
        ),
      ),
      isDense: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12.0),
        isDense: true,
        hintStyle: TextStyle(color: Color.fromRGBO(199, 202, 216, 1)),
        filled: true,
        fillColor: Color.fromRGBO(241, 245, 251, 1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), borderSide: BorderSide(color: Colors.transparent)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), borderSide: BorderSide(color: Colors.transparent)),
      ),
      elevation: 2,
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Country can't be empty";
        } else if (value == null) {
          return "Country can't be empty";
        }
        return null;
      },
      onSaved: (value) {
        widget.onSave(widget.type, value);
      },
    );
  }
}
