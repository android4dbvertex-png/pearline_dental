import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();

  final isLoading = false.obs;
  final secondsRemaining = 30.obs;
  late final String phoneNumber;

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments?['phone'] ?? '';
    _startTimer();
  }

  void _startTimer() {
    secondsRemaining.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        return true;
      }
      return false;
    });
  }

  void resendOtp() {
    if (secondsRemaining.value > 0) return;
    // TODO: API call for resend OTP
    _startTimer();
    Get.snackbar(
      'OTP Sent',
      'OTP resent successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> verifyOtp() async {
    final enteredOtp = otp1.text + otp2.text + otp3.text + otp4.text;

    if (enteredOtp.length < 4) {
      Get.snackbar(
        'Error',
        'Please enter complete OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      StorageService.setLoggedIn(true);
      Get.offAllNamed(AppRoutes.home);
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

  @override
  void onClose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    super.onClose();
  }
}
