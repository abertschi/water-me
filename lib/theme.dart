import 'package:flutter/material.dart';

Color c1_2 = Color.fromRGBO(49, 73, 60, 0.6);
Color c1 = Color.fromRGBO(49, 73, 60, 1); // 31493CFF

Color c2 = Color.fromRGBO(49, 73, 60, 0.8);
Color c3 = Color.fromRGBO(184, 12, 9, 1.0);

var materialColor = MaterialColor(
  c1.value,
  <int, Color>{
    50: c1,
    100: c1,
    200: c1,
    300: c1,
    400: c1,
    500: c1,
    600: c1,
    700: c1,
    800: c1,
    900: c1,
  },
);

final appTheme = ThemeData(
    primaryColor: c1,
    fontFamily: 'Raleway',
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: materialColor,
      primaryColorDark: c1,
      accentColor: c1,
      backgroundColor: c1,
      errorColor: Colors.white,
    ),
    scaffoldBackgroundColor: c1,
    backgroundColor: c1);

MaterialButton buttonTemplate(
    {required String text, required VoidCallback? onPressed}) {
  return MaterialButton(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5.0)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          )
        ]),
      ));
}
