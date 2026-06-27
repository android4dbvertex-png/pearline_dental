import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';

class OurServicesController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final services = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;

      final response = await _dio.get(ApiEndpoints.services);

      print('Services Response: ${response.data}');

      if (response.data['success'] == true) {
        final data = List<Map<String, dynamic>>.from(
          response.data['data'].map((e) => Map<String, dynamic>.from(e)),
        );
        services.assignAll(data);
      }
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      } else {
        errorMsg = 'No internet connection';
      }
      print('Services Error: $errorMsg');
    } finally {
      isLoading.value = false;
    }
  }
}
