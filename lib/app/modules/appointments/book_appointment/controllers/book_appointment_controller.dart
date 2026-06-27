import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/modules/appointments/my_appointments/controllers/my_appointments_controller.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

class BookAppointmentController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController patientNameController;
  late final TextEditingController problemController;

  final isLoading = false.obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTimeSlot = RxnString();

  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  final List<String> timeSlots = _generateTimeSlots();

  static List<String> _generateTimeSlots() {
    final slots = <String>[];
    for (int hour = 8; hour < 20; hour++) {
      slots.add('${_formatTime(hour, 0)} - ${_formatTime(hour, 30)}');
      slots.add('${_formatTime(hour, 30)} - ${_formatTime(hour + 1, 0)}');
    }
    return slots;
  }

  static String _formatTime(int hour, int minute) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  final isSelfBooking = true.obs;

  void toggleBookingType(bool isSelf) {
    isSelfBooking.value = isSelf;
    if (isSelf) {
      final user = StorageService.getUser();
      if (user != null) {
        final name = user['name'] ??
            (user['email'] != null
                ? user['email'].toString().split('@')[0]
                : '');
        patientNameController.text = name;
      }
    } else {
      patientNameController.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();

    formKey = GlobalKey<FormState>();
    patientNameController = TextEditingController();
    problemController = TextEditingController();

    final user = StorageService.getUser();
    if (user != null) {
      final name = user['name'] ??
          (user['email'] != null
              ? user['email'].toString().split('@')[0]
              : '');
      patientNameController.text = name;
    }

    checkPreviousAppointment();
  }

  Future<void> checkPreviousAppointment() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.myAppointments,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getToken()}',
          },
        ),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final hasAppointments = data is List && data.isNotEmpty;
        StorageService.setAppointmentBooked(hasAppointments);
        print('Has previous appointments: $hasAppointments');
      }
    } catch (e) {
      print('Check appointment error: $e');
      StorageService.setAppointmentBooked(false);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF29B6F6),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      selectedDate.value = picked;
      selectedTimeSlot.value = null; // Reset selected time
    }
  }

  String get formattedDate {
    if (selectedDate.value == null) return 'Select Date';

    final d = selectedDate.value!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  /// Returns true if the slot is available.
  bool isTimeSlotAvailable(String slot) {
    if (selectedDate.value == null) return true;

    final selected = selectedDate.value!;
    final now = DateTime.now();

    // Future dates: all slots allowed
    if (selected.year != now.year ||
        selected.month != now.month ||
        selected.day != now.day) {
      return true;
    }

    // Parse slot start time
    final start = slot.split(' - ').first;

    final parts = start.split(' ');
    final time = parts[0];
    final period = parts[1];

    final hm = time.split(':');

    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    final slotDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    return slotDateTime.isAfter(now);
  }

  Future<void> bookAppointment() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select appointment date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedTimeSlot.value == null) {
      Get.snackbar(
        'Error',
        'Please select appointment time',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isTimeSlotAvailable(selectedTimeSlot.value!)) {
      Get.snackbar(
        'Error',
        'Selected time slot has already passed.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _dio.post(
        ApiEndpoints.bookAppointment,
        data: {
          'patientName': patientNameController.text.trim(),
          'appointmentDate': formattedDate,
          'appointmentTime': selectedTimeSlot.value,
          'problem': problemController.text.trim(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getToken()}',
          },
        ),
      );

      print('Appointment Response: ${response.data}');

      Get.back();

      await Future.delayed(const Duration(milliseconds: 300));

      if (Get.isRegistered<MyAppointmentsController>()) {
        await Get.find<MyAppointmentsController>().fetchAppointments();
      }

      Get.snackbar(
        'Success',
        'Appointment booked successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';

      if (e.response != null) {
        final errData = e.response?.data;
        errorMsg = (errData is Map
            ? errData['message']?.toString()
            : null) ??
            errorMsg;
        print('Error: ${e.response?.data}');
      } else {
        errorMsg = 'No internet connection';
      }

      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    patientNameController.dispose();
    problemController.dispose();
    super.onClose();
  }
}