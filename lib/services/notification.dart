import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_me/main.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  bool _init = false;
  NotificationService._internal();
  static const channelId = '1';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (_init) return;

    _init = true;
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: showApp);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    '1',
    'water_me',
    channelDescription: 'water notification',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showWateringNotification(int plantsToWater) async {

    await flutterLocalNotificationsPlugin.show(
      0,
      "Water me",
      "You have $plantsToWater plants to water.",
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future showApp(String? payload) async {
  main();
}
