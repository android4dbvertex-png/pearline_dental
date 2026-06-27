import 'package:get/get.dart';
import 'package:pearline_dental/app/modules/notifications/controllers/notifications_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => ProfileController());
    }

}
