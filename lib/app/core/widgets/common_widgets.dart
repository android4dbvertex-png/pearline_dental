import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Custom AppBar ─────────────────────────────────────────────────────────────
class PearlineAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const PearlineAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showBack
          ? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_left, color: Colors.black87),
              ),
            )
          : null,
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ─── Primary Button ────────────────────────────────────────────────────────────
class PearlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  final double? width;

  const PearlineButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}

// ─── Custom TextField ──────────────────────────────────────────────────────────
class PearlineTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const PearlineTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ─── Home Grid Card ────────────────────────────────────────────────────────────
class HomeGridCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HomeGridCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.3,
                child: Icon(icon, size: 48, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Settings Menu Item ────────────────────────────────────────────────────────
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final VoidCallback onTap;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconBgColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State Widget ────────────────────────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          if (buttonText != null) ...[
            const SizedBox(height: 24),
            PearlineButton(
              text: buttonText!,
              onTap: onButtonTap!,
              width: 150,
            ),
          ],
        ],
      ),
    );
  }
}
