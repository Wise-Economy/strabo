import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/Connections.dart';
import '../models/User.dart';

class AppState {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount currentUser;
  SharedPreferences preferences;

  User user;

  //Connections BLOC
  Connections _connections = Connections();

  Connections get connections => _connections;

  dispose() {
    currentUser = null;
    googleSignIn = null;
    preferences = null;
    user = null;
    connections.dispose();
  }
}
