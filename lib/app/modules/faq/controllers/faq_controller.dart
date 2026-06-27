import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class FaqController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final faqs = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final expandedIndex = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(ApiEndpoints.faq);
      if (response.data['success'] == true) {
        faqs.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      print('FAQ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = null;
    } else {
      expandedIndex.value = index;
    }
  }
}
