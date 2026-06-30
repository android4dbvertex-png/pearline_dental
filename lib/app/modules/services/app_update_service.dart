import 'package:in_app_update/in_app_update.dart';

class AppUpdateService {
  static Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability ==
          UpdateAvailability.updateAvailable) {

        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }

        // Flexible Update
        // if (info.flexibleUpdateAllowed) {
        //   await InAppUpdate.startFlexibleUpdate();
        //   await InAppUpdate.completeFlexibleUpdate();
        // }
      }
    } catch (e) {
      print("Update Error: $e");
    }
  }
}