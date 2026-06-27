import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    // Debug: force navigate to login for now
    Get.offAllNamed(AppRoutes.login);

    // Later replace with:
    // if (StorageService.isLoggedIn) {
    //   Get.offAllNamed(AppRoutes.home);
    // } else {
    //   Get.offAllNamed(AppRoutes.login);
    // }
  }
}
