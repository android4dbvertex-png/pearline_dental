import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text('FAQ'),
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
          return _ShimmerFaq();
        }
        if (controller.faqs.isEmpty) {
          return const Center(
            child: Text(
              'No FAQs available',
              style: TextStyle(color: AppColors.textGrey),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchFaqs,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              final faq = controller.faqs[index];
              return Obx(() {
                final isExpanded = controller.expandedIndex.value == index;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // ✅ Material wrap — ListTile ink splash fix
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (_) => controller.toggleExpand(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'Q',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        faq['question'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  'A',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  faq['answer'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textGrey,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        );
      }),
    );
  }
}

class _ShimmerFaq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
