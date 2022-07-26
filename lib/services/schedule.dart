import 'package:water_me/services/notification.dart';
import 'package:workmanager/workmanager.dart';

import 'db.dart';

class ScheduleService {
  static final ScheduleService _service = ScheduleService._internal();

  factory ScheduleService() {
    return _service;
  }

  ScheduleService._internal();
  onWork() {
    Workmanager().executeTask((task, inputData) async {
      try {
        Db db = Db();
        var model = await db.loadModel();
        if (model.isWateringDue()) {
          var s = NotificationService();
          await s.init();
          s.showNotifications();
          print('watering is due');
        }
      } catch (err) {
        print(err);
        throw Exception(err);
      }
      return Future.value(true);
    });
  }

  init() {
    Workmanager().initialize(onWork, isInDebugMode: true);
    Workmanager().registerOneOffTask("task-identifier", "simpleTask");
    Workmanager().registerPeriodicTask('water-me', 'simplePeriodicTask',
        frequency: Duration(minutes: 15));
  }
}
