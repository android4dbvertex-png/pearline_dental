import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/gallery_controller.dart';

class GalleryView extends GetView<GalleryController> {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gallery'),
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
      body: Column(
        children: [
          // ── Tab Bar ──
          Obx(() => Container(
                color: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        title: 'Photos',
                        icon: Icons.photo_library_rounded,
                        isSelected: controller.selectedTab.value == 0,
                        onTap: () => controller.changeTab(0),
                      ),
                      _TabButton(
                        title: 'Videos',
                        icon: Icons.ondemand_video_sharp,
                        isSelected: controller.selectedTab.value == 1,
                        onTap: () => controller.changeTab(1),
                      ),
                    ],
                  ),
                ),
              )),

          // ── Content ──
          Expanded(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.selectedTab.value == 0
                    ? _PhotosGrid(
                        key: const ValueKey('photos'), controller: controller)
                    : _VideosList(
                        key: const ValueKey('videos'), controller: controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Button ──
class _TabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? AppColors.primary : Colors.white,
                  size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Photos Grid ──
class _PhotosGrid extends StatelessWidget {
  final GalleryController controller;

  const _PhotosGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPhotos.value) {
        return _ShimmerGrid();
      }
      if (controller.photos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library_outlined,
                  size: 64, color: AppColors.grey.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              const Text(
                'No photos available',
                style: TextStyle(color: AppColors.textGrey, fontSize: 15),
              ),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.fetchPhotos,
        child: MasonryGridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: controller.photos.length,
          itemBuilder: (context, index) {
            final photo = controller.photos[index];
            return GestureDetector(
              onTap: () => _showFullImage(context, photo['imageUrl'], index),
              child: Hero(
                tag: 'photo_$index',
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Image ──
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: photo['imageUrl'],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 150,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 150,
                            color: AppColors.greyLight,
                            child: const Icon(Icons.broken_image,
                                color: AppColors.grey),
                          ),
                        ),
                      ),
                      // ── Title ──
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          photo['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  void _showFullImage(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('Pinch to zoom',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
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

// ── Videos List ──
class _VideosList extends StatelessWidget {
  final GalleryController controller;

  const _VideosList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingVideos.value) {
        return _ShimmerList();
      }
      if (controller.videos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library_outlined,
                  size: 64, color: AppColors.grey.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              const Text('No videos available',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.fetchVideos,
        child: Container(
          color: const Color(0xFFF3F5F9),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.videos.length,
            itemBuilder: (context, index) {
              final video = controller.videos[index];
              final thumbnailUrl =
                  controller.getYoutubeThumbnail(video['videoUrl']);

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE8EAF0), // visible light border
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _openVideo(video['videoUrl']),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Thumbnail ──
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: thumbnailUrl,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.greyLight,
                                  child: const Icon(Icons.video_library,
                                      color: AppColors.grey, size: 32),
                                ),
                              ),

                              // Darken bottom slightly so it doesn't look flat
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.25),
                                      ],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),

                              // Play button
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.play_arrow_rounded,
                                      color: Colors.red, size: 28),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Content ──
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['title'] ?? 'Video',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  // YouTube tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.play_circle_fill,
                                            size: 12, color: Colors.red),
                                        const SizedBox(width: 4),
                                        Text('YouTube',
                                            style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),

                                  // Watch Now button
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Watch',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward_rounded,
                                            size: 14, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Future<void> _openVideo(String videoUrl) async {
    final url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Shimmer Grid ──
class _ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: 8,
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: index % 3 == 0 ? 200 : 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ── Shimmer List ──
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 85,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
