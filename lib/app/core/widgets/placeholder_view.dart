import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction_rounded,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon...',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
