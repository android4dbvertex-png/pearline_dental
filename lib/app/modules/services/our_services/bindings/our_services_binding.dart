import 'package:get/get.dart';
import '../controllers/our_services_controller.dart';

class OurServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OurServicesController>(
      () => OurServicesController(),
      fenix: true,
    );
  }
}
