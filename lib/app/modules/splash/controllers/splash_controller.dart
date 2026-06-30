import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../services/app_update_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {

    // Check for update first
    await AppUpdateService.checkForUpdate();
    await Future.delayed(const Duration(seconds: 3));

    Get.offAllNamed(AppRoutes.login);
    if (StorageService.isLoggedIn &&
        StorageService.getToken() != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
