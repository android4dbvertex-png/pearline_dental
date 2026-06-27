import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class TermsConditionsController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final content = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiEndpoints.termsConditions);
      if (response.data['success'] == true) {
        content.value = response.data['data']['content'] ?? '';
      }
    } catch (e) {
      print('T&C Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
