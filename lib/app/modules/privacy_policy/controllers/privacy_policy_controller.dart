import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class PrivacyPolicyController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final content = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiEndpoints.privacyPolicy);
      if (response.data['success'] == true) {
        content.value = response.data['data']['content'] ?? '';
      }
    } catch (e) {
      print('Privacy Policy Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
