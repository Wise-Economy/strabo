import 'package:rxdart/rxdart.dart';

import '../models/User.dart';

class Register {
  // User Name
  final _userNameController = BehaviorSubject<String>();

  ValueStream<String> get userNameStream => _userNameController.stream;

  get changeUserName => _userNameController.sink.add;

  String get userName => _userNameController.value;

  //User Mobile Number
  final _mobileNumberController = BehaviorSubject<String>();

  ValueStream<String> get mobileNumberStream => _mobileNumberController.stream;

  get changeMobileNumber => _mobileNumberController.sink.add;

  String get userMobileNumber => _mobileNumberController.value;

  //User Mobile Number Country Code
  final _mobileNumberCountryCodeController = BehaviorSubject<String>();

  ValueStream<String> get mobileNumberCountryCodeStream => _mobileNumberCountryCodeController.stream;

  get changeMobileNumberCountryCode => _mobileNumberCountryCodeController.sink.add;

  String get userMobileNumberCountryCode => _mobileNumberCountryCodeController.value;

  //UserResidence
  final _userResidenceController = BehaviorSubject<String>();

  ValueStream<String> get userResidenceStream => _userResidenceController.stream;

  get changeUserResidence => _userResidenceController.sink.add;

  String get userResidence => _userResidenceController.value;

  //Day
  final _userDOBDayController = BehaviorSubject<String>();

  ValueStream<String> get userDOBDayStream => _userDOBDayController.stream;

  get changeUserDOBDay => _userDOBDayController.sink.add;

  String get userDOBDay => _userDOBDayController.value;

  //Month
  final _userDOBMonthController = BehaviorSubject<String>();

  ValueStream<String> get userDOBMonthStream => _userDOBMonthController.stream;

  get changeUserDOBMonth => _userDOBMonthController.sink.add;

  String get userDOBMonth => _userDOBMonthController.value;


  //Year
  final _userDOBYearController = BehaviorSubject<String>();

  ValueStream<String> get userDOBYearStream => _userDOBYearController.stream;

  get changeUserDOBYear => _userDOBYearController.sink.add;

  String get userDOBYear => _userDOBYearController.value;

  //DOB Merger

  Stream<bool> get userDOBStream =>
      CombineLatestStream.combine3(userDOBYearStream, userDOBMonthStream, userDOBDayStream, (year,month,day) => true);

  validateFormFields() {

    bool isValid = true;
    if (userName == null || userName.isEmpty) {
      _userNameController.sink.addError('Invalid Username');
      isValid = false;
    }
    if (userDOBDay == null || userDOBDay.isEmpty || int.parse(userDOBDay) > 31) {
      _userDOBDayController.sink.addError('Invalid DOB');
      isValid = false;
    } else if (userDOBMonth == null || userDOBMonth.isEmpty || int.parse(userDOBMonth) > 12) {
      _userDOBMonthController.sink.addError('Invalid DOB');
      isValid = false;
    } else if (userDOBYear == null || userDOBYear.isEmpty || userDOBYear.length < 4) {
      _userDOBYearController.sink.addError('Invalid DOB');
      isValid = false;
    }
    if (userMobileNumber == null || userMobileNumber.isEmpty || userMobileNumber.length < 10) {
      _mobileNumberController.sink.addError('Invalid Mobile Number');
      isValid = false;
    }
    return isValid;
  }
  
  User getFormValues() {
    return User(
        fullName: userName,
        dateOfBirth: '$userDOBYear-$userDOBMonth-$userDOBDay',
        phoneNumber: "+$userMobileNumberCountryCode $userMobileNumber",
        residenceCountry:ResidenceCountry(
            countryId: int.parse('$userMobileNumberCountryCode'),
            countryName: "$userResidence"
        )
    );
  }
  
  dispose() {
    _userNameController.close();
    _mobileNumberController.close();
    _mobileNumberCountryCodeController.close();
    _userResidenceController.close();
    _userDOBDayController.close();
    _userDOBMonthController.close();
    _userDOBYearController.close();
  }
}
