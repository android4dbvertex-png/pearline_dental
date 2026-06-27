import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_appointment_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_validators.dart';

class BookAppointmentView extends GetView<BookAppointmentController> {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                const Text(
                  'Book Your Appointment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fill in the details to schedule your visit',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Booking For ──
                _buildLabel('Booking For'),
                const SizedBox(height: 8),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.toggleBookingType(true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: controller.isSelfBooking.value
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                boxShadow: controller.isSelfBooking.value
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    color: controller.isSelfBooking.value
                                        ? Colors.white
                                        : AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'For Myself',
                                    style: TextStyle(
                                      color: controller.isSelfBooking.value
                                          ? Colors.white
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.toggleBookingType(false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: !controller.isSelfBooking.value
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                                boxShadow: !controller.isSelfBooking.value
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_rounded,
                                    color: !controller.isSelfBooking.value
                                        ? Colors.white
                                        : AppColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'For Others',
                                    style: TextStyle(
                                      color: !controller.isSelfBooking.value
                                          ? Colors.white
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),

                // ── Patient Name ──
                _buildLabel('Patient Name'),
                const SizedBox(height: 8),
                Obx(() => TextFormField(
                      controller: controller.patientNameController,
                      readOnly: controller.isSelfBooking.value,
                      validator: (v) =>
                          AppValidators.validateRequired(v, 'Patient Name'),
                      decoration: InputDecoration(
                        hintText: 'Enter patient name',
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.grey),
                        filled: controller.isSelfBooking.value,
                        fillColor: controller.isSelfBooking.value
                            ? AppColors.greyLight
                            : Colors.white,
                      ),
                    )),
                const SizedBox(height: 20),

                // ── Appointment Date ──
                _buildLabel('Appointment Date'),
                const SizedBox(height: 8),
                Obx(() => GestureDetector(
                      onTap: () => controller.pickDate(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 20),

                // ── Time Slot ──
                _buildLabel('Appointment Time'),
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
                          hint: const Text(
                            'Select time slot',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 15,
                            ),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.access_time,
                              color: AppColors.primary),
                          items: controller.timeSlots
                              .where((slot) => controller.isTimeSlotAvailable(slot))
                              .map(
                                (slot) => DropdownMenuItem<String>(
                              value: slot,
                              child: Text(slot),
                            ),
                          )
                              .toList(),
                          onChanged: (val) =>
                              controller.selectedTimeSlot.value = val,
                        ),
                      ),
                    )),
                const SizedBox(height: 20),

                // ── Problem ──
                _buildLabel('Problem / Reason'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.problemController,
                  maxLines: 4,
                  validator: (v) =>
                      AppValidators.validateRequired(v, 'Problem'),
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
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Book Button ──
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.bookAppointment,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Book Appointment'),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textGrey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
