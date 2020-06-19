import 'package:finwise/blocs/Connections.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  GoogleSignInAccount currentUser;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile'
    ],
  );
  SharedPreferences preferences;

  Connections get connections => Connections();

  dispose() {
    connections.dispose();
  }
}