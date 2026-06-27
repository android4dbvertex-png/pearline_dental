import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          // ── Info Section ──
          const _SectionHeader(title: 'Information'),
          _SettingsItem(
            icon: Icons.question_answer_rounded,
            iconColor: AppColors.cardBlue,
            title: 'FAQ',
            onTap: controller.goToFaq,
          ),
          _SettingsItem(
            icon: Icons.phone_rounded,
            iconColor: Colors.green,
            title: 'Contact Us',
            onTap: controller.goToContactUs,
          ),
          _SettingsItem(
            icon: Icons.info_rounded,
            iconColor: AppColors.cardOrange,
            title: 'About Us',
            onTap: controller.goToAboutUs,
          ),
          _SettingsItem(
            icon: Icons.description_rounded,
            iconColor: AppColors.cardPurple,
            title: 'Terms & Conditions',
            onTap: controller.goToTermsConditions,
          ),
          _SettingsItem(
            icon: Icons.privacy_tip_rounded,
            iconColor: AppColors.primaryDark,
            title: 'Privacy Policy',
            onTap: controller.goToPrivacyPolicy,
          ),

          const SizedBox(height: 12),

          // ── Account Section ──
          const _SectionHeader(title: 'Account'),
          _SettingsItem(
            icon: Icons.logout_rounded,
            iconColor: AppColors.accentRed,
            title: 'Logout',
            onTap: controller.logout,
            showDivider: false,
          ),

          const SizedBox(height: 24),

          // ── App Version ──
          const Center(
            child: Text(
              'Pearlline Dental v1.0.0',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Section Header ──
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textGrey,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ── Settings Item ──
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 56, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
