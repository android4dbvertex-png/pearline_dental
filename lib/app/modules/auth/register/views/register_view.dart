import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_validators.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Register'),
        leading: GestureDetector(
          onTap: controller.goToLogin,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text('Create Account',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                const SizedBox(height: 24),

                // ── Name ──
                _buildLabel('Full Name'),
                TextFormField(
                  controller: controller.nameController,
                  validator: (v) => AppValidators.validateRequired(v, 'Name'),
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon:
                        Icon(Icons.person_outline, color: AppColors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Email ──
                _buildLabel('Email'),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon:
                        Icon(Icons.email_outlined, color: AppColors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Mobile ──
                _buildLabel('Mobile Number'),
                TextFormField(
                  controller: controller.mobileNoController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: AppValidators.validatePhone,
                  decoration: const InputDecoration(
                    hintText: 'Enter your mobile number',
                    prefixIcon:
                        Icon(Icons.phone_outlined, color: AppColors.grey),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 16),

                // ── DOB ──
                _buildLabel('Date of Birth'),
                TextFormField(
                  controller: controller.dobController,
                  readOnly: true,
                  onTap: () => controller.pickDob(context),
                  validator: (v) =>
                      AppValidators.validateRequired(v, 'Date of Birth'),
                  decoration: const InputDecoration(
                    hintText: 'YYYY-MM-DD',
                    prefixIcon: Icon(Icons.calendar_today_outlined,
                        color: AppColors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Address ──
                _buildLabel('Address'),
                TextFormField(
                  controller: controller.addressController,
                  validator: (v) =>
                      AppValidators.validateRequired(v, 'Address'),
                  decoration: const InputDecoration(
                    hintText: 'Enter your address',
                    prefixIcon:
                        Icon(Icons.location_on_outlined, color: AppColors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Password ──
                _buildLabel('Password'),
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: AppValidators.validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Create password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.grey),
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
                    )),
                const SizedBox(height: 16),

                // ── Confirm Password ──
                _buildLabel('Confirm Password'),
                Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      validator: controller.validateConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.grey),
                        suffixIcon: GestureDetector(
                          onTap: controller.toggleConfirmPasswordVisibility,
                          child: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 36),

                // ── Register Button ──
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.register,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Register'),
                      ),
                    )),
                const SizedBox(height: 24),

                // ── Login Link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: const Text('Login',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
    );
  }
}
