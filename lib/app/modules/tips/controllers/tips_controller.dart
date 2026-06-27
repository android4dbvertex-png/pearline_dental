import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class TipsController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final tips = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTips();
  }

  Future<void> fetchTips() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiEndpoints.tips);
      if (response.data['success'] == true) {
        tips.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      print('Tips Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
