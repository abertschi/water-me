import 'dart:io';

import 'package:flutter/material.dart';

import '../theme.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Image.file(File(imagePath)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
              child: Center(
                child: buttonTemplate(
                    text: "SAVE PICTURE",
                    onPressed: () => {Navigator.pop(context, imagePath)}),
              ))
        ])));
  }
}
