import 'dart:io';

import 'package:flutter/material.dart';

import '../theme.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    var buttonSavePicture = buttonTemplate(
      text: "SAVE PICTURE",
      onPressed: () => {Navigator.pop(context, imagePath)}
    );

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(8, 32, 8, 16),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Image.file(File(imagePath)),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 0,
              child: buttonSavePicture
            ),
          ],
        ),
      )
    );

  }
}
