import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import '../controllers/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('Contact Us'),
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
        child: Column(
          children: [
            // ── Header Banner ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                      Icons.headset_mic_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'We are happy to help you!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Direct Contact ────────────────────────────────
                  const Text(
                    'Get In Touch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Phone
                  _ContactCard(
                    icon: Icons.phone_rounded,
                    iconColor: Colors.green,
                    title: 'Phone',
                    subtitle: controller.phone,
                    onTap: controller.launchPhone,
                  ),
                  const SizedBox(height: 10),

                  // Email
                  _ContactCard(
                    icon: Icons.email_rounded,
                    iconColor: AppColors.primary,
                    title: 'Email',
                    subtitle: controller.email,
                    onTap: controller.launchEmail,
                  ),
                  const SizedBox(height: 24),

                  // ── Social Media ──────────────────────────────────
                  const Text(
                    'Follow Us',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Social Icons Row
                  Row(
                    children: [
                      // WhatsApp
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.chat_rounded,
                          label: 'WhatsApp',
                          color: const Color(0xFF25D366),
                          onTap: controller.launchWhatsapp,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Facebook
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.facebook_rounded,
                          label: 'Facebook',
                          color: const Color(0xFF1877F2),
                          onTap: controller.launchFacebook,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Instagram
                      Expanded(
                        child: _SocialCard(
                          icon: Icons.camera_alt_rounded,
                          label: 'Instagram',
                          color: const Color(0xFFE1306C),
                          onTap: controller.launchInstagram,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Business Hours ────────────────────────────────
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Business Hours',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _HourRow(
                            day: 'Monday - Saturday',
                            time: '9:00 AM - 8:00 PM'),
                        const SizedBox(height: 8),
                        const _HourRow(day: 'Sunday', time: 'Closed'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Social Card ───────────────────────────────────────────────────────────────
class _SocialCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hour Row ──────────────────────────────────────────────────────────────────
class _HourRow extends StatelessWidget {
  final String day;
  final String time;

  const _HourRow({required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    final isClosed = time == 'Closed';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isClosed ? AppColors.accentRed : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
