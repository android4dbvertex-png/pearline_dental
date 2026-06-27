import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class AboutUsController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final isLoading = false.obs;
  final htmlContent = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;

      final response = await _dio.get(ApiEndpoints.aboutUs);

      print('About Us Response: ${response.data}');

      if (response.data['success'] == true) {
        htmlContent.value = response.data['data']['description'] ?? '';
      }
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      } else {
        errorMsg = 'No internet connection';
      }
      print('About Us Error: $errorMsg');
    } finally {
      isLoading.value = false;
    }
  }
}
