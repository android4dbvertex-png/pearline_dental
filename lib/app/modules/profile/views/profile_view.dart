import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── Header ──
              _buildHeader(context),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Personal Info ──
                    const _SectionTitle(title: 'Personal Information'),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _InfoTile(
                          icon: Icons.phone_rounded,
                          iconColor: AppColors.primary,
                          label: 'Mobile Number',
                          value: controller.mobile.value,
                          isFirst: true,
                        ),
                        _Divider(),
                        _InfoTile(
                          icon: Icons.cake_rounded,
                          iconColor: const Color(0xFFCE93D8),
                          label: 'Date of Birth',
                          value: controller.dob.value,
                        ),
                        _Divider(),
                        _InfoTile(
                          icon: Icons.location_on_rounded,
                          iconColor: const Color(0xFFFFB74D),
                          label: 'Address',
                          value: controller.address.value,
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Actions ──
                    const _SectionTitle(title: 'Account Actions'),
                    const SizedBox(height: 12),
                    _InfoCard(
                      children: [
                        _InfoTile(
                          icon: Icons.calendar_today_rounded,
                          iconColor: AppColors.primary,
                          label: 'Member Since',
                          value: controller.memberSince.value,
                          isFirst: true,
                        ),
                        _Divider(),
                        _ActionTile(
                          icon: Icons.lock_rounded,
                          iconColor: const Color(0xFF9575CD),
                          title: 'Change Password',
                          onTap: () => _showChangePasswordSheet(context),
                          isLast: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(
            children: [
              // ── Top Row — Edit Button ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => _showEditProfileSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Avatar ──
              GestureDetector(
                onTap: controller.pickAndUploadPhoto,
                child: Stack(
                  children: [
                    Obx(() => Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: controller.profileImage.value.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: controller.profileImage.value,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => _AvatarInitial(
                                        name: controller.name.value),
                                    errorWidget: (_, __, ___) => _AvatarInitial(
                                        name: controller.name.value),
                                  )
                                : _AvatarInitial(name: controller.name.value),
                          ),
                        )),

                    // Upload indicator
                    Obx(() => controller.isUploadingPhoto.value
                        ? Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),

                    // Camera icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Name
              Obx(() => Text(
                    controller.name.value,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(height: 4),

              // Email
              Obx(() => Text(
                    controller.email.value,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  )),
              const SizedBox(height: 16),

              // Member Since Badge
              Obx(() => controller.memberSince.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Member since ${controller.memberSince.value}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit Profile Bottom Sheet ──
  void _showEditProfileSheet(BuildContext context) {
    controller.resetProfileFields();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Edit Profile',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Name
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Mobile
              // Mobile (read-only — cannot be edited)
              _buildLabel('Mobile Number'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.mobileController,
                keyboardType: TextInputType.phone,
                readOnly: true,
                enabled: false,
                style: GoogleFonts.poppins(color: AppColors.grey),
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),

              // Address
              _buildLabel('Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter your address',
                  prefixIcon:
                      Icon(Icons.location_on_outlined, color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button

              Column(
                children: [
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isUpdating.value
                            ? null
                            : controller.updateProfile,
                        child: controller.isUpdating.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // match Save button's radius
                        ),
                      ),
                      onPressed: () {
                        controller.resetProfileFields();
                        Get.back();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ), // closes Save/Cancel Column
            ], // closes outer Column's children list
          ), // closes outer Column
        ), // closes SingleChildScrollView
      ), // closes Container
      isScrollControlled: true,
      ignoreSafeArea: false,
    ); // closes Get.bottomSheet
  } // closes _showEditProfileSheet

  // ── Change Password Bottom Sheet ──
  void _showChangePasswordSheet(BuildContext context) {
    controller.resetPasswordFields();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Change Password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Old Password
              _buildLabel('Current Password'),
              const SizedBox(height: 8),
              Obx(() => TextFormField(
                    controller: controller.oldPasswordController,
                    obscureText: !controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Enter current password',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: AppColors.grey),
                      suffixIcon: GestureDetector(
                        onTap: controller.togglePasswordVisibility,
                        child: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              // New Password
              _buildLabel('New Password'),
              const SizedBox(height: 8),
              Obx(() => TextFormField(
                    controller: controller.newPasswordController,
                    obscureText: !controller.isNewPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: AppColors.grey),
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleNewPasswordVisibility,
                        child: Icon(
                          controller.isNewPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              // Confirm Password
              _buildLabel('Confirm New Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm new password',
                  prefixIcon: Icon(Icons.lock_outline, color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // Change Button
              // Change Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isChangingPassword.value
                          ? null
                          : () {
                              // Validation
                              if (controller
                                  .oldPasswordController.text.isEmpty) {
                                Get.snackbar('Error', 'Enter current password',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              if (controller.newPasswordController.text.length <
                                  6) {
                                Get.snackbar('Error',
                                    'New password must be at least 6 characters',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              if (controller.newPasswordController.text !=
                                  controller.confirmPasswordController.text) {
                                Get.snackbar('Error', 'Passwords do not match',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              controller.changePassword();
                            },
                      child: controller.isChangingPassword.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Change Password',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // match Save button's radius
                    ),
                  ),
                  onPressed: () {
                    controller.resetProfileFields();
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.textGrey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ── Avatar Initial ──
class _AvatarInitial extends StatelessWidget {
  final String name;
  const _AvatarInitial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'P',
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ── Section Title ──
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

// ── Info Card ──
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ── Info Tile ──
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 16 : 8,
        bottom: isLast ? 16 : 8,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Not provided',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        value.isNotEmpty ? AppColors.textDark : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Tile ──
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.isLast = false,
  }) : isFirst = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: isFirst ? 16 : 8,
          bottom: isLast ? 16 : 8,
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Divider ──
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Color(0xFFEEEEEE)),
    );
  }
}
