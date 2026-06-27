import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';
import 'package:pearline_dental/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:pearline_dental/app/routes/app_routes.dart';

/// Background handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background Message: ${message.messageId}");
}

class FcmService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl),
  );

  static const String _channelId = "high_importance_channel";

  Future<FcmService> init() async {
    await _requestPermission();

    await _initLocalNotifications();

    _listenForegroundMessages();

    _listenNotificationTap();

    await _registerTokenIfLoggedIn();

    _fcm.onTokenRefresh.listen((token) async {
      print("NEW FCM TOKEN: $token");
      await _sendTokenToBackend(token);
    });
    return this;
  }

  Future<void> _requestPermission() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");

    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await _local.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _onTap(response.payload);
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      "High Importance Notifications",
      description: "Admin Notifications",
      importance: Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔥 FOREGROUND PUSH RECEIVED");
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
      _showNotification(message);

      _refreshNotifications();
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    await _local.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title ?? '',
      body: notification.body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _listenNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _onTap(jsonEncode(message.data));
    });

    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        _onTap(jsonEncode(message.data));
      }
    });
  }

  Future<void> _onTap(String? payload) async {
    _refreshNotifications();

    Get.toNamed(AppRoutes.notifications);
  }

  void _refreshNotifications() {
    if (Get.isRegistered<NotificationsController>()) {
      final controller = Get.find<NotificationsController>();

      controller.fetchNotifications();

      controller.fetchUnreadCount();
    }
  }

  Future<void> _registerTokenIfLoggedIn() async {
    final authToken = StorageService.getToken();

    if (authToken == null || authToken.isEmpty) return;

    final token = await _fcm.getToken();

    print("FCM TOKEN: $token");

    if (token != null) {
      await _sendTokenToBackend(token);
    }
  }

  Future<void> registerTokenAfterLogin() async {
    final token = await _fcm.getToken();

    if (token != null) {
      await _sendTokenToBackend(token);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await _dio.post(
        "/users/fcm-token",
        data: {
          "fcmToken": token,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${StorageService.getToken()}",
          },
        ),
      );
      print("FCM TOKEN: $token");
      print("POST URL: ${ApiEndpoints.baseUrl}/users/fcm-token");
      print("✅ FCM token uploaded successfully");
    } catch (e) {
      print("❌ FCM token registration failed: $e");
    }
  }
}
