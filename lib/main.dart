import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'package:pearline_dental/app/modules/services/fcm_service.dart';

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

// MUST be top-level (outside any class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // You can update local DB / badge count here too if needed
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Get.putAsync(() => FcmService().init());
  runApp(const PearlineDentalApp());
}

class PearlineDentalApp extends StatelessWidget {
  const PearlineDentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pearlline Dental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
