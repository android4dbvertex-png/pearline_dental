import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_validators.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // ── Logo ──────────────────────────────────────────────
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'PEARLLINE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  'DENTAL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                    letterSpacing: 5,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Title ─────────────────────────────────────────────
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Email Field ───────────────────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'E-mail/Mobile',
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
                    hintText: 'Your email or number',
                  ),
                ),
                const SizedBox(height: 20),

                // ── Password Field ────────────────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Your Password',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    validator: AppValidators.validatePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Forgot Password ───────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.goToForgotPassword,
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Login Button ──────────────────────────────────────
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.login,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Register Link ─────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    GestureDetector(
                      onTap: controller.goToRegister,
                      child: const Text(
                        'Register',
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
