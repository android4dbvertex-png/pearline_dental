import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';

class NotificationDetailView extends StatelessWidget {
  const NotificationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final item = Map<String, dynamic>.from(args['item'] ?? {});
    final timeAgo = args['timeAgo'] ?? '';

    final hasImage =
        item['imageUrl'] != null && item['imageUrl'].toString().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('Notification'),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            if (hasImage)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: item['imageUrl'],
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
                        Icons.notifications_rounded,
                        size: 48,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),

            if (hasImage) const SizedBox(height: 20),

            // ── Title + time ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Full message ──
            Text(
              item['message'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textGrey,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}