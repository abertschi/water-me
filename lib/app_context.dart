import 'package:camera/camera.dart';
import 'package:water_me/services/db.dart';
import 'package:water_me/services/notification.dart';
import 'package:water_me/services/schedule.dart';

import 'models/app_model.dart';

class AppContext {
  late Db db = Db();
  late AppModel model;
  late CameraDescription? camera;
  late NotificationService? notifications;
  late ScheduleService schedule;

  init() async {
    // XXX: We only need model data after invocation
    await initModel();
    initCamera();
    initNotifications();
    initSchedule();

  }

  initSchedule() {
    schedule = ScheduleService();
    schedule.init();
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
    model.addListener(() {
      saveModel();
    });
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