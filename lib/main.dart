import 'package:finwise/screens/IntialAddBank.dart';
import 'package:finwise/screens/PasscodeScreen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'models/AppState.dart';
import 'screens/InitScreen.dart';

void main() {
  runApp(
    Provider(
      create: (context) => AppState(),
      dispose: (context, AppState appState) => appState.dispose(),
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiseeco',
      theme: theme(),
      home: InitScreen(),
    );
  }
}

ThemeData theme() {
  Map<int, Color> color = {
    50: Color.fromRGBO(71, 115, 175, .1),
    100: Color.fromRGBO(71, 115, 175, .2),
    200: Color.fromRGBO(71, 115, 175, .3),
    300: Color.fromRGBO(71, 115, 175, .4),
    400: Color.fromRGBO(71, 115, 175, .5),
    500: Color.fromRGBO(71, 115, 175, .6),
    600: Color.fromRGBO(71, 115, 175, .7),
    700: Color.fromRGBO(71, 115, 175, .8),
    800: Color.fromRGBO(71, 115, 175, .9),
    900: Color.fromRGBO(71, 115, 175, 1),
  };
  MaterialColor colorCustom = MaterialColor(0xFF4773af, color);
  return ThemeData(
    primarySwatch: colorCustom,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  );
}
