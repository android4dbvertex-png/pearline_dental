import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:pearline_dental/app/routes/app_routes.dart';

class SettingsController extends GetxController {
  void goToFaq() => Get.toNamed(AppRoutes.faq);
  void goToContactUs() => Get.toNamed(AppRoutes.contactUs);
  void goToAboutUs() => Get.toNamed(AppRoutes.aboutUs);
  void goToTermsConditions() => Get.toNamed(AppRoutes.termsConditions);
  void goToPrivacyPolicy() => Get.toNamed(AppRoutes.privacyPolicy);

  void logout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.accentRed,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // ── Title ──
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),

              // ── Subtitle ──
              const Text(
                'Are you sure you want to\nlogout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // ── Buttons ──
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.greyLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Logout
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        StorageService.clearAll();
                        Get.offAllNamed(AppRoutes.login);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentRed.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
