import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/my_appointments_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';

class MyAppointmentsView extends GetView<MyAppointmentsController> {
  final bool showBackButton;
  const MyAppointmentsView({super.key, this.showBackButton = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text(
          'My Appointments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? GestureDetector(
                onTap: () => Get.back(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchAppointments,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _ShimmerList();
        }
        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No Appointments Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Book your first appointment today!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchAppointments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.appointments.length,
            itemBuilder: (context, index) {
              final appointment = controller.appointments[index];
              return _AppointmentCard(appointment: appointment);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.bookAppointment),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Book New',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Appointment Card ──
class _AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  const _AppointmentCard({required this.appointment});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return Colors.red;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.access_time_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = appointment['status'] ?? 'Pending';
    final statusColor = _getStatusColor(status);

    // Format date
    String formattedDate = '';
    try {
      final date = DateTime.parse(appointment['appointmentDate']);
      formattedDate =
          '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
    } catch (e) {
      formattedDate = appointment['appointmentDate'] ?? '';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top Color Bar ──
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        appointment['patientName'] ?? 'Patient',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatusIcon(status),
                              size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // ── Date ──
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: formattedDate,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),

                // ── Time ──
                _InfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: appointment['appointmentTime'] ?? '',
                  color: const Color(0xFF9575CD),
                ),
                const SizedBox(height: 8),

                // ── Problem ──
                _InfoRow(
                  icon: Icons.medical_information_rounded,
                  label: 'Problem',
                  value: appointment['problem'] ?? '',
                  color: Colors.orange,
                ),
                // ── Edit Button (only shows on  Pending) ──
                if (status.toLowerCase() == 'pending') ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showEditSheet(context, appointment),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit_rounded,
                              color: AppColors.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Edit Appointment',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, Map<String, dynamic> appointment) {
    final controller = Get.find<MyAppointmentsController>();
    controller.prepareEdit(appointment);
    final appointmentId = appointment['_id'];

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
                'Edit Appointment',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // ── Date ──
              Text('Appointment Date',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primary, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            controller.formattedDate,
                            style: TextStyle(
                              color: controller.selectedDate.value == null
                                  ? AppColors.grey
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              // ── Time ──
              Text('Appointment Time',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 8),
              Obx(() => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedTimeSlot.value,
                        hint: const Text('Select time slot'),
                        isExpanded: true,
                        icon: const Icon(Icons.access_time,
                            color: AppColors.primary),
                        items: controller.timeSlots
                            .map((slot) => DropdownMenuItem(
                                  value: slot,
                                  child: Text(slot),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedTimeSlot.value = val,
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              // ── Problem ──
              Text('Problem / Reason',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGrey, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.problemController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe your problem...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Save Button ──
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () => controller.updateAppointment(appointmentId),
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
                              'Update Appointment',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }
}

// ── Info Row ──
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Shimmer ──
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
