import 'package:get/get.dart';
import '../controllers/tips_controller.dart';

class TipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TipsController>(() => TipsController());
  }
}
