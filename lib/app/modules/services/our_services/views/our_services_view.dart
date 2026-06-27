import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/our_services_controller.dart';
import '../../../../core/theme/app_theme.dart';

class OurServicesView extends GetView<OurServicesController> {
  const OurServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('Our Services'),
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
          return _ShimmerServices();
        }

        // ── Empty ──
        if (controller.services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 64,
                  color: AppColors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No services available',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }

        // ── List ──
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchServices,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              final service = controller.services[index];
              return _ServiceCard(service: service, index: index);
            },
          ),
        );
      }),
    );
  }
}

// ── Service Card ──────────────────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final int index;

  const _ServiceCard({
    required this.service,
    required this.index,
  });

  // Alternating pill colors like original app
  Color get _pillColor {
    final colors = [
      const Color(0xFFAB47BC), // purple
      const Color(0xFFFFB74D), // orange
      const Color(0xFFEF9A9A), // pink
      const Color(0xFF81C784), // green
      const Color(0xFF64B5F6), // blue
      const Color(0xFFF06292), // pink2
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = service['imageUrl'] != null &&
        service['imageUrl'].toString().isNotEmpty;

    return GestureDetector(
      onTap: () {

          Get.toNamed(AppRoutes.serviceDetail, arguments: service);

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Image ──
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: service['imageUrl'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.greyLight,
                        child: const Icon(
                          Icons.medical_services_outlined,
                          size: 48,
                          color: AppColors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.greyLight,
                      child: const Icon(
                        Icons.medical_services_outlined,
                        size: 48,
                        color: AppColors.grey,
                      ),
                    ),
            ),

            // ── Gradient overlay ──
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),

            // ── Title pill at bottom ──
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: _pillColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  service['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ── Chevron ──
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer ───────────────────────────────────────────────────────────────────
class _ShimmerServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 200,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
