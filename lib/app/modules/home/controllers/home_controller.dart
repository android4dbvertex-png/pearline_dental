import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/modules/appointments/my_appointments/controllers/my_appointments_controller.dart';
import 'package:pearline_dental/app/modules/profile/controllers/profile_controller.dart';
import 'package:pearline_dental/app/modules/settings/controllers/settings_controller.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final banners = <Map<String, dynamic>>[].obs;
  final isLoadingBanners = false.obs;
  final currentBannerIndex = 0.obs;

  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  @override
  void onInit() {
    super.onInit();
    // NotificationsController is already registered via HomeBinding's
    // lazyPut — it fetches its own notifications + unread count in its
    // onInit. No need to find/fetch or re-put it here.
    Get.put(SettingsController());
    Get.put(MyAppointmentsController());
    Get.put(ProfileController());
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoadingBanners.value = true;
      final response = await _dio.get(ApiEndpoints.banners);
      if (response.data['success'] == true) {
        banners.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      print('Banners Error: $e');
    } finally {
      isLoadingBanners.value = false;
    }
  }

  void changeTab(int index) => currentIndex.value = index;
  void changeBanner(int index) => currentBannerIndex.value = index;
}