import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings: initSettings);
}

class Notificationservice {
  Notificationservice();

  Future<void> scheduleTodoNotification(Todo todo) async {
    final formater = DateFormat("yyyy-MM-dd HH:mm");
    final DateTime dueDate = formater.parse(todo.dueDate!);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: todo.id.hashCode, // notification id
      title: 'Todo Reminder', // notification title
      body: todo.title, // notification body
      scheduledDate: tz.TZDateTime.from(dueDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Notifications',
          channelDescription: 'Reminders for todos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime, // optional
    );
  }
}
