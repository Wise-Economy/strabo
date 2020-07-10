import 'package:finwise/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/API.dart';
import '../models/User.dart';
import '../models/Countries.dart';
import '../models/AppState.dart';
import '../models/GConnect.dart';
import '../blocs/Register.dart';
import '../screens/PasscodeScreen.dart';

class RegisterScreen extends StatefulWidget {
  final User user;
  final bool isExistingUser;

  RegisterScreen({this.user, this.isExistingUser});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _register = Register();
  User _user;
  String _buttonLabel = "Continue";
  bool _inProgress = false;
  OurServer _ourServer;
  SharedPreferences _prefsInstance;
  List<String> _countryIds = [];
  List<String> _countries = [];
  bool _progress = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _register.changeUserName(_user?.fullName ?? "");
    _ourServer = Provider.of<OurServer>(context, listen: false);
    _prefsInstance = Provider.of<AppState>(context, listen: false).preferences;
    fetchCountries();
  }

  fetchCountries() async {
    http.Response response = await _ourServer.fetchEnablesCountries();
    if (response.statusCode == 200) {
      CountryList countryList = CountryList.fromRawJson(response.body);
      for (Country c in countryList.countries) {
        _countryIds.add('${c.countryId}');
        _countries.add(c.countryName);
      }
      setState(() {
        _progress = false;
      });
    } else {
      setState(() {
        _progress = false;
        _hasError = true;
      });
    }
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
          child: _progress
              ? Center(
                  child: Text('Just a moment ...'),
                )
              : Column(
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
                                padding: EdgeInsets.all(16.0),
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
                                                  fontSize: 12,
                                                  color: Colors.red.shade800,
                                                  fontWeight: FontWeight.normal),
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
                                          Flexible(
                                            child: CountryPhoneCodes(register: _register, countryCodes: _countryIds),
                                          ),
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
                                                  maxLength: 15,
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
                                                    hintStyle: TextStyle(
                                                        color: Color.fromRGBO(199, 202, 216, 1), fontSize: 16.0),
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
                                      child: Text(
                                        'Country of Residence',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    CountryOptions(register: _register, countries: _countries),
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
                          onPressed: _inProgress
                              ? null
                              : () async {
                                  if (_register.validateFormFields()) {
                                    User formUser = _register.getFormValues();
                                    formUser = formUser.copyWith(email: _user.email, profilePhoto: _user.profilePhoto);
                                    String sessionId = _prefsInstance.getString(Constants.SESSION_ID);
                                    setState(() {
                                      _inProgress = true;
                                    });
                                    http.Response response = await _ourServer.register(formUser, sessionId);
                                    if (response.statusCode == 200) {
                                      setState(() {
                                        _inProgress = false;
                                      });
                                      GConnect gConnect = GConnect.fromRawJson(response.body);
                                      Provider.of<AppState>(context, listen: false).user = gConnect.user;
                                      _prefsInstance.setString(Constants.USER_INFO,gConnect.user.toRawJson() );
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PasscodeScreen(
                                              isExistingUser: widget.isExistingUser,
                                            ),
                                          ),
                                          (route) => false);
                                    } else {
                                      setState(() {
                                        _inProgress = false;
                                      });
                                    }
                                  }
                                },
                          child: Text(
                            _inProgress ? 'Just a moment ... ' : 'Continue',
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
  final List<String> countries;

  CountryOptions({Key key, this.register, this.countries});

  @override
  CountryOptionsState createState() => CountryOptionsState();
}

class CountryOptionsState extends State<CountryOptions> {
  String country;
  List<String> _countries;

  @override
  void initState() {
    super.initState();
    _countries = widget.countries;
    country = _countries[0];
    widget.register.changeUserResidence(country);
  }


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
        'Country of Residence',
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
  final List<String> countryCodes;

  CountryPhoneCodes({Key key, this.register, this.countryCodes});

  @override
  CountryPhoneCodesState createState() => CountryPhoneCodesState();
}

class CountryPhoneCodesState extends State<CountryPhoneCodes> {
  String code;
  List<String> _codes;

  @override
  void initState() {
    super.initState();
    _codes = widget.countryCodes;
    code = '${_codes[0]}';
    widget.register.changeMobileNumberCountryCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: code,
      items: _codes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('+$value'),
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
