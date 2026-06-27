import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';
import '../../../../core/theme/app_theme.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black87),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // ── Icon ──
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Title ──
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We have sent a 4-digit OTP to\n${controller.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // ── OTP Fields ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OtpBox(
                        controller: controller.otp1, nextFocus: FocusNode()),
                    _OtpBox(
                        controller: controller.otp2, nextFocus: FocusNode()),
                    _OtpBox(
                        controller: controller.otp3, nextFocus: FocusNode()),
                    _OtpBox(controller: controller.otp4, isLast: true),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Resend OTP ──
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Didn't receive OTP? ",
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                        controller.secondsRemaining.value > 0
                            ? Text(
                                'Resend in ${controller.secondsRemaining.value}s',
                                style: const TextStyle(color: AppColors.grey),
                              )
                            : GestureDetector(
                                onTap: controller.resendOtp,
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ],
                    )),
                const SizedBox(height: 40),

                // ── Verify Button ──
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.verifyOtp,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Verify OTP'),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── OTP Input Box Widget ──
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? nextFocus;
  final bool isLast;

  const _OtpBox({
    required this.controller,
    this.nextFocus,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && !isLast) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
