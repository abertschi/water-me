import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'display_picture.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var button = buttonTemplate(
        text: "TAKE PICTURE",
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();
            if (!mounted) return;
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
            if (res != null) {
              Navigator.pop(context, res);
            }
          } catch (e) {
            print(e);
          }
        });

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(child:  Column(children: [
              CameraPreview(_controller),
              const SizedBox(height: 40.0),
              button
            ]));
          } else {
            return const Center(child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        },
      ),
    );
  }
}
