import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import 'package:pearline_dental/app/modules/services/fcm_service.dart';

class LoginController extends GetxController {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      print('Login Response: ${response.data}');

      final token = response.data['token'];
      if (token != null) {
        StorageService.saveToken(token);
        StorageService.setLoggedIn(true);
      }

      final user = response.data['user'];
      if (user != null) {
        StorageService.saveUser(Map<String, dynamic>.from(user));
      }

      Get.snackbar(
        'Success',
        'Login successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<FcmService>().registerTokenAfterLogin();

      Get.offAllNamed(AppRoutes.home);
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
        print('Error: ${e.response?.data}');
      } else {
        errorMsg = 'No internet connection';
      }
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToForgotPassword() => Get.toNamed(AppRoutes.forgotPassword);
  void goToRegister() => Get.toNamed(AppRoutes.register);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
