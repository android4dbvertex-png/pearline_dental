import 'package:cached_network_image/cached_network_image.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:pearline_dental/app/modules/appointments/my_appointments/views/my_appointments_view.dart';
import 'package:pearline_dental/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:pearline_dental/app/modules/settings/controllers/settings_controller.dart';
import 'package:pearline_dental/app/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';
import '../../profile/views/profile_view.dart';
import '../../settings/views/settings_view.dart';
import '../../profile/controllers/profile_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String _getGreeting() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = StorageService.getUser();
    final userEmail = user?['email'] ?? '';
    final userName = user?['name'] ??
        (userEmail.isNotEmpty ? userEmail.split('@')[0] : 'Patient');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      drawer: _buildDrawer(userName, user?['email'] ?? ''),
      body: Obx(() =>
          IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _HomeContent(userName: userName, greeting: _getGreeting()),
              // showBackButton: false — bottom bar se
              const MyAppointmentsView(showBackButton: false),
              const ProfileView(),
              const SettingsView(),
            ],
          )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Bottom Nav ──
  Widget _buildBottomNav() {
    return Obx(() =>
        CurvedNavigationBar(
          index: controller.currentIndex.value,
          height: 60,
          color: AppColors.primary,
          buttonBackgroundColor: AppColors.primary,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) => controller.changeTab(index),
          items: const [
            Icon(Icons.home_rounded, color: Colors.white, size: 28),
            Icon(Icons.calendar_today_rounded, color: Colors.white, size: 26),
            Icon(Icons.person_rounded, color: Colors.white, size: 28),
            Icon(Icons.settings_rounded, color: Colors.white, size: 26),
          ],
        ));
  }

// ── Drawer ──
  Widget _buildDrawer(String fallbackName, String fallbackEmail) {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put<ProfileController>(ProfileController(), permanent: true);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
            child: Obx(() {
              final imageUrl = profileController.profileImage.value;
              final name = profileController.name.value.isNotEmpty
                  ? profileController.name.value
                  : fallbackName;
              final email = profileController.email.value.isNotEmpty
                  ? profileController.email.value
                  : fallbackEmail;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            _DrawerAvatarInitial(name: name),
                        errorWidget: (_, __, ___) =>
                            _DrawerAvatarInitial(name: name),
                      )
                          : _DrawerAvatarInitial(name: name),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 12),
          _DrawerItem(
            icon: Icons.lightbulb_rounded,
            iconColor: const Color(0xFFFFB74D),
            title: 'Tips',
            subtitle: 'Dental care tips',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.tips);
            },
          ),
          _DrawerItem(
            icon: Icons.chat_rounded,
            iconColor: AppColors.primary,
            title: 'Chat',
            subtitle: 'Talk to support',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.chat);
            },
          ),
          _DrawerItem(
            icon: Icons.payment_rounded,
            iconColor: const Color(0xFF9575CD),
            title: 'Payment',
            subtitle: 'Manage payments',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.payment);
            },
          ),
          const Divider(indent: 20, endIndent: 20),
          _DrawerItem(
            icon: Icons.settings_rounded,
            iconColor: AppColors.grey,
            title: 'Settings',
            subtitle: 'App preferences',
            onTap: () {
              Get.back();
              controller.changeTab(3);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.find<SettingsController>().logout();
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: Text('Logout',
                    style: GoogleFonts.poppins(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Text(
            'Pearlline Dental v1.0.0',
            style: GoogleFonts.poppins(color: AppColors.grey, fontSize: 11),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Drawer Avatar Initial (fallback) ──
class _DrawerAvatarInitial extends StatelessWidget {
  final String name;
  const _DrawerAvatarInitial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'P',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

}

class _BannerSection extends StatelessWidget {
  const _BannerSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isLoadingBanners.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }

      if (controller.banners.isEmpty) return const SizedBox.shrink();

      return Column(
        children: [
          // ── Carousel ──
          FlutterCarousel(
            options: FlutterCarouselOptions(
              height: 185,
              viewportFraction: 0.88,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 600),
              autoPlayCurve: Curves.fastOutSlowIn,
              showIndicator: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) => controller.changeBanner(index),
            ),
            items: controller.banners.map((banner) {
              return GestureDetector(
                onTap: () => Get.toNamed(
                  AppRoutes.bannerDetail,
                  arguments: banner,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: banner['imageUrl'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.greyLight,
                            child: const Icon(Icons.broken_image,
                                color: AppColors.grey, size: 40),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                        if (banner['title'] != null)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    banner['title'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // ── Dots Indicator ──
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.banners.asMap().entries.map((entry) {
                  final isActive =
                      controller.currentBannerIndex.value == entry.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              )),
        ],
      );
    });
  }
}

// ── Home Content ──
class _HomeContent extends StatelessWidget {
  final String userName;
  final String greeting;

  const _HomeContent({required this.userName, required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ──
        Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, $userName 👋',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Your smile is our priority 😊',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Get.toNamed(AppRoutes.notifications);

                      Get.find<NotificationsController>().fetchNotifications();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: Colors.white, size: 22),
                          // Badge
                          Obx(() {
                            final count = Get.find<NotificationsController>()
                                .unreadCount
                                .value;
                            if (count == 0) return const SizedBox.shrink();
                            return Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  count > 99 ? '99+' : count.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Scrollable Body ──
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ── Quick Access ──
                Text(
                  'Quick Access',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                // const SizedBox(height: 8),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _ModernCard(
                      title: 'Book\nAppointment',
                      subtitle: 'Schedule a visit',
                      icon: Icons.calendar_today_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1FA2FF), Color(0xFF0066CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.bookAppointment),
                    ),
                    _ModernCard(
                      title: 'My\nAppointments',
                      subtitle: 'View history',
                      icon: Icons.assignment_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCE93D8), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.myAppointments),
                    ),
                    _ModernCard(
                      title: 'Our\nServices',
                      subtitle: 'What we offer',
                      icon: Icons.medical_services_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB74D), Color(0xFFE65100)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.services),
                    ),
                    _ModernCard(
                      title: 'Gallery',
                      subtitle: 'Photos & videos',
                      icon: Icons.photo_library_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9575CD), Color(0xFF4527A0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.gallery),
                    ),
                  ],
                ),

                // Quick Access cards ke NICHE yeh add karo
                const SizedBox(height: 24),

                // ── Banners ──
                Text(
                  'Health Tips & Offers',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                const _BannerSection(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Modern Card ──
class _ModernCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ModernCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Drawer Item ──
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textGrey,
        ),
      ),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
      onTap: onTap,
    );
  }
}
