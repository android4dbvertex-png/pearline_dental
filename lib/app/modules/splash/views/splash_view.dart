import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      print('isLoggedIn: ${StorageService.isLoggedIn}');
      if (StorageService.isLoggedIn) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PEARLLINE',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const Text(
              'DENTAL',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
