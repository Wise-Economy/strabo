import 'package:flutter/material.dart';

import '../blocs/Register.dart';
import '../screens/PasscodeScreen.dart';

class RegisterScreen extends StatefulWidget {
  final String username;
  final bool isExistingUser;

  RegisterScreen({this.username, this.isExistingUser});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _register = Register();
  String _buttonLabel = "Continue";
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _register.changeUserName(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Register',
          ),
        ),
        body: SafeArea(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                child: Text('Name',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                              StreamBuilder(
                                stream: _register.userNameStream,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    autofocus: false,
                                    enableInteractiveSelection: true,
                                    maxLength: 100,
                                    initialValue: _register.userName,
                                    onChanged: _register.changeUserName,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      counterText: "",
                                      errorText: snapshot.error,
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
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                child: Text('Date of Birth',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(241, 245, 251, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        autofocus: false,
                                        enableInteractiveSelection: true,
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        textAlign: TextAlign.center,
                                        onChanged: _register.changeUserDOBDay,
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counterText: "",
                                          contentPadding: EdgeInsets.all(12.0),
                                          hintText: 'DD',
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
                                      ),
                                    ),
                                    Text('/'),
                                    Flexible(
                                      child: TextFormField(
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        enableInteractiveSelection: true,
                                        keyboardType: TextInputType.number,
                                        onChanged: _register.changeUserDOBMonth,
                                        maxLength: 2,
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counterText: "",
                                          contentPadding: EdgeInsets.all(12.0),
                                          hintText: 'MM',
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
                                      ),
                                    ),
                                    Text('/'),
                                    Flexible(
                                      child: TextFormField(
                                        autofocus: false,
                                        textAlign: TextAlign.center,
                                        enableInteractiveSelection: true,
                                        keyboardType: TextInputType.number,
                                        maxLength: 4,
                                        onChanged: _register.changeUserDOBYear,
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counterText: "",
                                          contentPadding: EdgeInsets.all(12.0),
                                          hintText: 'YYYY',
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                stream: _register.userDOBStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 12, top: 8),
                                      child: Text(
                                        "Invalid DOB",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red.shade800, fontWeight: FontWeight.normal),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                child: Text('Mobile',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(child: CountryPhoneCodes(register: _register)),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: StreamBuilder(
                                        stream: _register.mobileNumberStream,
                                        builder: (context, snapshot) {
                                          return TextFormField(
                                            autofocus: false,
                                            enableInteractiveSelection: true,
                                            maxLength: 10,
                                            maxLines: 1,
                                            onChanged: _register.changeMobileNumber,
                                            keyboardType: TextInputType.phone,
                                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
                                            decoration: InputDecoration(
                                              errorText: snapshot.error,
                                              isDense: true,
                                              counterText: "",
                                              alignLabelWithHint: true,
                                              contentPadding: EdgeInsets.all(12.0),
                                              hintText: 'Mobile',
                                              hintStyle:
                                                  TextStyle(color: Color.fromRGBO(199, 202, 216, 1), fontSize: 16.0),
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
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                child: Text('Country of residence',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    )),
                              ),
                              CountryOptions(register: _register),
                              const SizedBox(height: 15),
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
                  padding: EdgeInsets.all(18.0),
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
                      if (_register.validateFields()) {
                        print('Form has Valid Fields');
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

  @override
  void dispose() {
    _register.dispose();
    super.dispose();
  }
}

class CountryOptions extends StatefulWidget {
  final Register register;

  CountryOptions({Key key, this.register});

  @override
  CountryOptionsState createState() => CountryOptionsState();
}

class CountryOptionsState extends State<CountryOptions> {
  String country;
  final _countries = ["INDIA", "GERMANY", "UK"];

  @override
  void initState() {
    super.initState();
    country = _countries[0];
    widget.register.changeUserResidence(country);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: country,
      items: _countries.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          country = newValue;
          widget.register.changeUserResidence(country);
        });
      },
      hint: Text(
        'Country of residence',
        style: TextStyle(
          color: Color.fromRGBO(199, 202, 216, 1),
        ),
      ),
      isDense: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(11.0),
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
    );
  }
}

class CountryPhoneCodes extends StatefulWidget {
  final Register register;

  CountryPhoneCodes({Key key, this.register});

  @override
  CountryPhoneCodesState createState() => CountryPhoneCodesState();
}

class CountryPhoneCodesState extends State<CountryPhoneCodes> {
  String code;
  final _codes = ["+91", "+49", "+44"];

  @override
  void initState() {
    super.initState();
    code = _codes[0];
    widget.register.changeMobileNumberCountryCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: code,
      items: _codes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        setState(() {
          code = newValue;
          widget.register.changeMobileNumberCountryCode(code);
        });
      },
      hint: Text(
        'code',
        style: TextStyle(
          color: Color.fromRGBO(199, 202, 216, 1),
        ),
      ),
      isDense: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(11.0),
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
    );
  }
}
