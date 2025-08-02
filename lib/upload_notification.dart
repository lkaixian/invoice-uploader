import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

class UploadNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showProgress(int progress) async {
    final androidDetails = AndroidNotificationDetails(
      'upload_channel',
      'File Uploads',
      channelDescription: 'Shows upload progress',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Uploading Receipt',
      '$progress%',
      notificationDetails,
    );
  }

  static Future<void> showError(String errorMessage) async {
    await _notificationsPlugin.show(
      0,
      'Upload Failed',
      errorMessage,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'upload_channel',
          'File Uploads',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> showSuccess() async {
    await _notificationsPlugin.show(
      1,
      'Upload Completed',
      'Your receipt was uploaded successfully!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'upload_channel',
          'File Uploads',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> cancel() async {
    await _notificationsPlugin.cancel(0);
  }
}
