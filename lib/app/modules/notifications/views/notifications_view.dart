import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationsController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('Notifications'),
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
          return _ShimmerNotifications();
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_off_outlined,
                    size: 56,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No notifications yet!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll notify you when something arrives',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return _NotificationCard(
                item: item,
                timeAgo: controller.timeAgo(item['createdAt'] ?? ''),
              );
            },
          ),
        );
      }),
    );
  }
}

// ── Notification Card ──
class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final String timeAgo;

  const _NotificationCard({
    required this.item,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        item['imageUrl'] != null && item['imageUrl'].toString().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image / Icon ──
                hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: item['imageUrl'],
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 56,
                              height: 56,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (_, __, ___) => _IconBox(),
                        ),
                      )
                    : _IconBox(),

                const SizedBox(width: 12),

                // ── Content ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['message'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Icon Box ──
class _IconBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.notifications_rounded,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}

// ── Shimmer ──
class _ShimmerNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 84,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
