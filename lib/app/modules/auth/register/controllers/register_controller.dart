import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';

class RegisterController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController mobileNoController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final TextEditingController dobController;
  late final TextEditingController addressController;

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    mobileNoController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    dobController = TextEditingController();
    addressController = TextEditingController();
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> pickDob(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobileNo': mobileNoController.text.trim(),
          'password': passwordController.text.trim(),
          'dob': dobController.text.trim(),
          'address': addressController.text.trim(),
        },
      );

      print('Register Response: ${response.data}');

      Get.back(); // ← pehle navigate

      await Future.delayed(
          const Duration(milliseconds: 300)); // ← screen render hone do

      Get.snackbar(
        // ← phir snackbar
        'Success',
        'Registration successful! Please login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm password required';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  void goToLogin() => Get.back();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
