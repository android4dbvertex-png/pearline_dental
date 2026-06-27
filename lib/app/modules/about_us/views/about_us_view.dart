import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About Us'),
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
        // ── Loading ──
        if (controller.isLoading.value) {
          return _ShimmerAboutUs();
        }

        // ── Empty ──
        if (controller.htmlContent.value.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: AppColors.grey.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No content available',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        // ── Content ──
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Banner ──
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pearlline Multispeciality Dentocare',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ── HTML Content ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Html(
                    data: controller.htmlContent.value,
                    style: {
                      'body': Style(
                        fontSize: FontSize(15),
                        color: AppColors.textDark,
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'h1': Style(
                        fontSize: FontSize(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        margin: Margins.only(bottom: 12),
                      ),
                      'h2': Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        margin: Margins.only(bottom: 10),
                      ),
                      'h3': Style(
                        fontSize: FontSize(16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      'p': Style(
                        margin: Margins.only(bottom: 12),
                        color: AppColors.textGrey,
                        lineHeight: const LineHeight(1.6),
                      ),
                      'strong': Style(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      'ul': Style(
                        margin: Margins.only(bottom: 12),
                      ),
                      'li': Style(
                        color: AppColors.textGrey,
                        margin: Margins.only(bottom: 6),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────
class _ShimmerAboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 160,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                5,
                (_) => Container(
                  height: 16,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
