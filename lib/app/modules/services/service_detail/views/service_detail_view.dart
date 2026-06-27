import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/service_detail_controller.dart';
import '../../../../core/theme/app_theme.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('Service Details'),
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
        final hasImage = controller.imageUrl.isNotEmpty;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: controller.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 200,
                            color: AppColors.greyLight,
                            child: const Icon(
                              Icons.medical_services_outlined,
                              size: 48,
                              color: AppColors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          color: AppColors.primary.withValues(alpha: 0.15),
                          child: const Icon(
                            Icons.medical_services_outlined,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Title ──
              Text(
                controller.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 16),

              // ── About ──
              const Text(
                'About this service',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                controller.description.isNotEmpty
                    ? controller.description
                    : 'No additional details available for this service yet.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
