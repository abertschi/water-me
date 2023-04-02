import 'dart:io';

import 'package:camera/camera.dart';
import 'package:water_me/services/db.dart';
import 'package:water_me/services/notification.dart';
import 'package:water_me/services/schedule.dart';

import 'models/app_model.dart';

class AppContext {
  late Db db = Db();
  late AppModel _model;
  late CameraDescription? camera;
  late NotificationService? notifications;
  late ScheduleService schedule;

  get model {
    return _model;
  }

  init() async {
    print("init app Context");
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
      db.saveModel(_model);
  }

  Future<File> exportModelToFile() async {
    final file = await db.exportFile;
    return await db.exportToFile(model, file);
  }

  exportPath() {
    return db.exportDbFilePath;
  }

  exportBackupPath() {
    return db.exportDbBackupPath;
  }

  // returns backup file or exception
  importModelFromFile() async {
    final file = await db.exportFile;
    final backupFile = await db.exportBackupFile;
    await db.exportToFile(model, backupFile);

    try {
      final jsonData = await file.readAsString();
      final appModel = db.importJsonString(jsonData);
      _initModel(appModel);
    } on Exception catch(_) {
      print("=== troubleshooting info: ");
      print("failed to import model");
      print("import model data: ${await file.readAsString()}");
      print("expected format: ${db.exportAsJsonString(new AppModel())}");
      rethrow;
    }
    
    return backupFile;
  }


  initNotifications() async {
    notifications = NotificationService();
    notifications?.init();
  }

  _initModel(AppModel model) async {
    _model = model;
    _model.addListener(() {
      saveModel();
    });
    saveModel();
  }

  initModel() async {
    var m = await db.loadModel();
    print(m);
    _initModel(m);
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
