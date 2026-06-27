import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_validators.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Forgot Password'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
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
                    Icons.lock_reset_rounded,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Title ──
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your registered email or phone\nto receive an OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // ── Email / Phone Field ──
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email / Phone',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email or phone',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ── Send OTP Button ──
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendOtp,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Send OTP'),
                      ),
                    )),
                const SizedBox(height: 24),

                // ── Back to Login ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Remember your password? ',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
