import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

class MyAppointmentsController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final appointments = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Edit controllers
  late final TextEditingController problemController;
  final selectedDate = Rxn<DateTime>();
  final selectedTimeSlot = RxnString();

  final List<String> timeSlots = _generateTimeSlots();

  static List<String> _generateTimeSlots() {
    final slots = <String>[];
    for (int hour = 8; hour < 20; hour++) {
      final start1 = _formatTime(hour, 0);
      final end1 = _formatTime(hour, 30);
      slots.add('$start1 - $end1');
      final start2 = _formatTime(hour, 30);
      final end2 = _formatTime(hour + 1, 0);
      slots.add('$start2 - $end2');
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
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  @override
  void onInit() {
    super.onInit();
    problemController = TextEditingController();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(
        ApiEndpoints.myAppointments,
        options: Options(
          headers: {'Authorization': 'Bearer ${StorageService.getToken()}'},
        ),
      );

      print('My Appointments: ${response.data}');

      if (response.data['success'] == true) {
        appointments.value = List<Map<String, dynamic>>.from(
          response.data['data'].map((e) => Map<String, dynamic>.from(e)),
        );
      }
    } on DioException catch (e) {
      print('Appointments Error: ${e.response?.data}');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Pre-fill edit fields ──
  void prepareEdit(Map<String, dynamic> appointment) {
    problemController.text = appointment['problem'] ?? '';
    selectedTimeSlot.value = appointment['appointmentTime'];

    try {
      selectedDate.value = DateTime.parse(appointment['appointmentDate']);
    } catch (_) {
      selectedDate.value = null;
    }
  }

  String get formattedDate {
    if (selectedDate.value == null) return 'Select Date';
    final d = selectedDate.value!;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? now,
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
    if (picked != null) selectedDate.value = picked;
  }

  // ── Update Appointment ──
  Future<void> updateAppointment(String appointmentId) async {
    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Please select date',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (selectedTimeSlot.value == null) {
      Get.snackbar('Error', 'Please select time',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isUpdating.value = true;

      final response = await _dio.put(
        '${ApiEndpoints.updateAppointment}/$appointmentId',
        data: {
          'appointmentDate': formattedDate,
          'appointmentTime': selectedTimeSlot.value,
          'problem': problemController.text.trim(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${StorageService.getToken()}'},
        ),
      );

      print('Update Response: ${response.data}');

      if (response.data['success'] == true) {
        Get.back();
        await fetchAppointments();
        Get.snackbar(
          'Success',
          'Appointment updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      print('Update Error: ${e.response?.data}');
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    problemController.dispose();
    super.onClose();
  }
}
