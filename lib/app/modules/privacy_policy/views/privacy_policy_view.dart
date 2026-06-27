import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return _ShimmerContent();
        }
        if (controller.content.isEmpty) {
          return const Center(
            child: Text('No content available',
                style: TextStyle(color: AppColors.textGrey)),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Html(data: controller.content.value),
        );
      }),
    );
  }
}

class _ShimmerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: List.generate(
            8,
            (_) => Container(
              height: 16,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
