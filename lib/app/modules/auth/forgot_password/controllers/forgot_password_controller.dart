import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final step = 1.obs; // 1: Email, 2: New Password

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Move to OTP screen with email
      Get.toNamed(
        AppRoutes.otp,
        arguments: {'phone': emailController.text.trim()},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password reset successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
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
    if (value != newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
