import 'package:get/get.dart';

class ServiceDetailController extends GetxController {
  final service = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      service.value = Map<String, dynamic>.from(args);
    }
  }

  String get title => service['title'] ?? 'Service';
  String get imageUrl => service['imageUrl'] ?? '';
  String get description =>
      service['description'] ?? service['details'] ?? '';
}