import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pearline_dental/app/modules/payments/controllers/payment_controller.dart';
import 'package:pearline_dental/app/modules/payments/models/payment_request_model.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Payments',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF29B6F6),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualPaymentSheet(context, controller),
        backgroundColor: const Color(0xFF0288D1),
        icon: const Icon(Icons.add_card_rounded, color: Colors.white),
        label: const Text(
          'Pay Manually',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFF29B6F6),
        onRefresh: () async {
          await controller.fetchPaymentRequests();
          await controller.fetchMyPayments();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                icon: Icons.pending_actions_rounded,
                title: 'Pending Payment Requests',
              ),
              const SizedBox(height: 12),
              _PendingRequestsSection(controller: controller),
              const SizedBox(height: 28),
              _SectionHeader(
                icon: Icons.history_rounded,
                title: 'Payment History',
              ),
              const SizedBox(height: 12),
              _PaymentHistorySection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF0288D1)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

// ── Manual Payment Bottom Sheet ──────────────────────────────────
void _showManualPaymentSheet(
    BuildContext context, PaymentController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ManualPaymentSheet(controller: controller),
  );
}

class _ManualPaymentSheet extends StatelessWidget {
  final PaymentController controller;

  const _ManualPaymentSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF29B6F6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payment_rounded,
                    color: Color(0xFF0288D1),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Make a Manual Payment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(
                    Icons.currency_rupee_rounded,
                    color: Color(0xFF0288D1),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Pay Button

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          Navigator.pop(context); // close sheet first
                          controller.createManualOrder();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF90CAF9),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
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

// ── Pending Payment Requests Section ───────────────────────────
class _PendingRequestsSection extends StatelessWidget {
  final PaymentController controller;

  const _PendingRequestsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingRequests.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(color: Color(0xFF29B6F6)),
          ),
        );
      }

      // Only show requests that are still pending
      final pendingOnly = controller.paymentRequests
          .where((r) => r.status.toLowerCase() == 'pending')
          .toList();

      if (pendingOnly.isEmpty) {
        return const _EmptyPendingRequests();
      }

      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pendingOnly.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final request = pendingOnly[index];
          return _PaymentRequestCard(
            request: request,
            controller: controller,
          );
        },
      );
    });
  }
}

// ── Payment Request Card (restyled: white card, colored accent) ──
class _PaymentRequestCard extends StatelessWidget {
  final PaymentRequestModel request;
  final PaymentController controller;

  const _PaymentRequestCard({
    required this.request,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFF29B6F6), width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon + title + description
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFF29B6F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF0288D1),
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            request.title,
            style: const TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            request.description,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              request.status.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF57F17),
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Amount
          Text(
            '₹${request.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Color(0xFF0288D1),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          // Pay Now button - full width, on its own line
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.createOrder(request),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0288D1),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF90CAF9),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State for Pending Requests ───────────────────────────
class _EmptyPendingRequests extends StatelessWidget {
  const _EmptyPendingRequests();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 44),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'No pending payments',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}

// ── Payment History Section ────────────────────────────────────
class _PaymentHistorySection extends StatelessWidget {
  final PaymentController controller;

  const _PaymentHistorySection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPayments.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: CircularProgressIndicator(color: Color(0xFF29B6F6)),
          ),
        );
      }

      if (controller.payments.isEmpty) {
        return const _EmptyPayments();
      }

      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.payments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final payment = controller.payments[index];
          return _PaymentTile(payment: payment);
        },
      );
    });
  }
}

// ── Payment Tile ───────────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final Map<String, dynamic> payment;

  const _PaymentTile({required this.payment});

  String _formatDate(dynamic raw) {
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return raw?.toString() ?? '—';
    }
  }

  String _formatAmount(dynamic amount) {
    try {
      final val = double.parse(amount.toString());
      return '₹${val.toStringAsFixed(2)}';
    } catch (_) {
      return '₹0.00';
    }
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'captured':
      case 'paid':
      case 'success':
        return const Color(0xFF2E7D32);
      case 'failed':
      case 'cancelled':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFFF57F17);
    }
  }

  Color _statusBg(String? status) {
    switch (status?.toLowerCase()) {
      case 'captured':
      case 'paid':
      case 'success':
        return const Color(0xFFE8F5E9);
      case 'failed':
      case 'cancelled':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  IconData _statusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'captured':
      case 'paid':
      case 'success':
        return Icons.check_circle_rounded;
      case 'failed':
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = payment['status']?.toString();
    final paymentId =
        payment['paymentId'] ?? payment['razorpay_payment_id'] ?? '—';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusBg(status),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(status),
              color: _statusColor(status),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dental Consultation',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'ID: $paymentId',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  _formatDate(payment['createdAt'] ?? payment['created_at']),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(payment['amount']),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg(status),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  (status ?? 'Pending').toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(status),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty State (Payment History) ───────────────────────────────
class _EmptyPayments extends StatelessWidget {
  const _EmptyPayments();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 44),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 56,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'No payments yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your payment history will appear here',
            style: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
          ),
        ],
      ),
    );
  }
}
