import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_me/models/app_model.dart';
import 'package:water_me/screens/plant_list.dart';
import 'package:water_me/services/db.dart';
import 'package:water_me/services/notification.dart';
import 'package:water_me/theme.dart';

class AppContext {
  Db db = Db();
  AppModel? model;
  CameraDescription? camera;
  NotificationService? notifications;

  init() async {
    initModel();
    initCamera();
    initNotifications();
  }

  saveModel() async {
    db.saveModel(model!);
  }

  initNotifications() async {
    notifications = NotificationService();
    notifications?.init();
  }

  initModel() async {
    model = await db.loadModel();
  }

  initCamera() async {
    try {
      final cameras = await availableCameras();
      camera = cameras.first;
    } on Exception catch (_) {
      print(_);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('c context');
  final AppContext c = AppContext();


  await c.initModel();
  c.initNotifications();
  c.initCamera();

  runApp(MyApp(appContext: c));
}

class MyApp extends StatefulWidget {
  final AppContext appContext;

  MyApp({super.key, required this.appContext}) {}

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>.value(value: widget.appContext.model!),
        Provider<AppContext>.value(value: widget.appContext),
      ],
      child: MaterialApp(
        title: 'Water me',
        theme: appTheme,
        initialRoute: '/myplants',
        routes: <String, WidgetBuilder>{
          '/myplants': (context) => MyPlants(),
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    widget.appContext.saveModel();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
