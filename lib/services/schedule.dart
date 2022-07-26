import 'package:water_me/services/notification.dart';
import 'package:workmanager/workmanager.dart';
import 'db.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      Db db = Db();
      var model = await db.loadModel();
      if (model.isWateringDue()) {
        var s = NotificationService();
        await s.init();
        s.showWateringNotification(model.plantsToWater());
        print('watering is due');
      }
    } catch (err) {
      print(err);
    }

    return Future.value(true);
  });
}

class ScheduleService {
  static final ScheduleService _service = ScheduleService._internal();
  bool _init = false;

  factory ScheduleService() {
    return _service;
  }

  ScheduleService._internal();

  init() {
    if (_init) return;
    _init = true;

    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager().registerPeriodicTask(
      'periodic-task',
      'periodic-task',
      frequency: Duration(hours: 12),
    );
  }
}
