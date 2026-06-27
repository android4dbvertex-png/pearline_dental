import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tips_controller.dart';

class TipsView extends GetView<TipsController> {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(
          'Dental Tips',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
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
          return _ShimmerList();
        }
        if (controller.tips.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 80, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  'No tips available',
                  style: GoogleFonts.poppins(
                    color: AppColors.textGrey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTips,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.tips.length,
            itemBuilder: (context, index) {
              final tip = controller.tips[index];
              return _TipCard(tip: tip);
            },
          ),
        );
      }),
    );
  }
}

class _TipCard extends StatelessWidget {
  final Map<String, dynamic> tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          _showFullImage(context, tip['imageUrl'] ?? '', tip['title'] ?? ''),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: tip['imageUrl'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.greyLight,
                    child: const Icon(
                      Icons.broken_image,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
            // ── Title ──
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                tip['title'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer List ──────────────────────────────────────────────────────────────
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 220,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
