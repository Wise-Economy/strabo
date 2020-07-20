import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/User.dart';

class AppState {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount currentUser;
  SharedPreferences preferences;
  User user;

  dispose() {
    currentUser = null;
    googleSignIn = null;
    preferences = null;
    user = null;
  }
}
