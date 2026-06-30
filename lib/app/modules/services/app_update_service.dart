import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/foundation.dart';

class AppUpdateService {
  static Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          try {
            await InAppUpdate.performImmediateUpdate();
          } catch (e) {
            if (kDebugMode) print('Immediate update failed: $e');
            // User likely cancelled or update flow was interrupted —
            // app continues running on the current version.
          }
        } else if (info.flexibleUpdateAllowed) {
          try {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          } catch (e) {
            if (kDebugMode) print('Flexible update failed: $e');
          }
        }
      }
    } catch (e) {
      // Expected on debug builds, emulators, or non-Play-Store installs
      if (kDebugMode) print('Update check error: $e');
    }
  }
}