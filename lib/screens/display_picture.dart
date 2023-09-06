import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../theme.dart';

class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const DisplayPictureScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Image.memory(imageBytes),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 50),
              child: Center(
                child: buttonTemplate(
                    text: "SAVE PICTURE",
                    onPressed: () => {Navigator.pop(context, imageBytes)}),
              ))
        ])));
  }
}
