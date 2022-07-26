import 'package:flutter/material.dart';

Color c1_2 = Color.fromRGBO(49, 73, 60, 0.6);
Color c1 = Color.fromRGBO(49, 73, 60, 1); // 31493CFF

Color c2 = Color.fromRGBO(49, 73, 60, 0.8);
Color c3 = Color.fromRGBO(184, 12, 9, 1.0);

final appTheme = ThemeData(
    primaryColor: c1,
    fontFamily: 'Raleway',
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
