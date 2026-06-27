import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:photo_view/photo_view.dart';

class BannerDetailView extends StatelessWidget {
  const BannerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = Get.arguments as Map<String, dynamic>;
    final imageUrl = banner['imageUrl'] ?? '';
    final title = banner['title'] ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Zoomable Image ──
          PhotoView(
            imageProvider: CachedNetworkImageProvider(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),

          // ── Close Button ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),

          // ── Title ──
          if (title.isNotEmpty)
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
