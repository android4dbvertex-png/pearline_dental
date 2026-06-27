import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';

class NotificationsController extends GetxController {
  final isLoading = false.obs;
  final notifications = <Map<String, dynamic>>[].obs;
  final unreadCount = 0.obs;

  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  static const String _userNotifications = "/user-notifications";
  static const String _markReadEndpoint = "/user-notifications/read";
  static const String _unreadCountEndpoint = "/user-notifications/unread-count";

  Timer? _pollTimer;

  Map<String, String> get _authHeader => {
        "Authorization": "Bearer ${StorageService.getToken()}",
      };

  @override
  void onInit() {
    super.onInit();

    fetchNotifications();
    fetchUnreadCount();

    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => fetchUnreadCount(),
    );
  }

  // ---------------- FETCH NOTIFICATIONS ----------------

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final response = await _dio.get(
        _userNotifications,
        options: Options(headers: _authHeader),
      );

      print("========== USER NOTIFICATIONS ==========");
      print(response.data);

      if (response.data["success"] == true) {
        notifications.assignAll(
          List<Map<String, dynamic>>.from(
            response.data["data"],
          ),
        );
        print(notifications.first);
      }
    } on DioException catch (e) {
      print("Notifications Error: ${e.response?.data}");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- UNREAD COUNT ----------------

  Future<void> fetchUnreadCount() async {
    try {
      final response = await _dio.get(
        _unreadCountEndpoint,
        options: Options(headers: _authHeader),
      );

      print("Unread Count Response: ${response.data}");

      unreadCount.value = _extractCount(response.data);

      print("Unread Count Value: ${unreadCount.value}");
    } on DioException catch (e) {
      print("Unread Count Error: ${e.response?.data ?? e.message}");
    }
  }

  int _extractCount(dynamic body) {
    if (body == null) return 0;

    final candidates = [
      body["unreadCount"],
      body["data"],
      body["count"],
      body["unread_count"],
    ];

    for (final c in candidates) {
      if (c is int) return c;

      if (c is String) {
        final value = int.tryParse(c);
        if (value != null) return value;
      }

      if (c is Map) {
        final nested = c["count"] ?? c["unreadCount"] ?? c["unread_count"];

        if (nested is int) return nested;

        if (nested is String) {
          final value = int.tryParse(nested);
          if (value != null) return value;
        }
      }
    }

    return 0;
  }

  // ---------------- MARK READ ----------------

  Future<void> markAllAsRead() async {
    final unread = notifications.where((e) => e["isRead"] != true).toList();

    if (unread.isEmpty) {
      unreadCount.value = 0;
      return;
    }

    // Update UI immediately
    unreadCount.value = 0;

    for (final n in unread) {
      n["isRead"] = true;
    }

    notifications.refresh();

    // Sync with backend
    for (final n in unread) {
      try {
        print("================================");
        print("POST URL: ${ApiEndpoints.baseUrl}$_markReadEndpoint");

        final body = {
          "notificationId": n["_id"],
          "notificationType": n["type"] ?? "global",
        };

        print("BODY: $body");

        final response = await _dio.patch(
          _markReadEndpoint,
          data: {
            "notificationId": n["_id"],
            "notificationType": n["type"] ?? "global",
          },
          options: Options(headers: _authHeader),
        );

        print("SUCCESS: ${response.statusCode}");
        print("RESPONSE: ${response.data}");
      } on DioException catch (e) {
        print("❌ MARK READ FAILED");
        print("STATUS: ${e.response?.statusCode}");
        print("PATH: ${e.requestOptions.path}");
        print("METHOD: ${e.requestOptions.method}");
        print("REQUEST: ${e.requestOptions.data}");
        print("RESPONSE: ${e.response?.data}");
      }
    }

    await fetchUnreadCount();
  }

  // ---------------- TIME AGO ----------------

  String timeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inDays > 7) {
        return "${date.day}/${date.month}/${date.year}";
      }
      if (diff.inDays >= 1) {
        return "${diff.inDays}d ago";
      }
      if (diff.inHours >= 1) {
        return "${diff.inHours}h ago";
      }
      if (diff.inMinutes >= 1) {
        return "${diff.inMinutes}m ago";
      }

      return "Just now";
    } catch (_) {
      return "";
    }
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
