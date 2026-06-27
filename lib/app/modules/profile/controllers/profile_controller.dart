import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';

class ProfileController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final _picker = ImagePicker();

  // ── Observables ──
  final name = ''.obs;
  final email = ''.obs;
  final mobile = ''.obs;
  final address = ''.obs;
  final dob = ''.obs;
  final memberSince = ''.obs;
  final profileImage = ''.obs;

  // ── Edit Controllers ──
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final TextEditingController addressController;

  // ── Password Controllers ──
  late final TextEditingController oldPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isUploadingPhoto = false.obs;
  final isChangingPassword = false.obs;
  final isPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    mobileController = TextEditingController();
    addressController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    fetchProfile();
  }

  // ── Fetch Profile ──
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _dio.get(
        ApiEndpoints.userProfile,
        options: Options(
          headers: {'Authorization': 'Bearer ${StorageService.getToken()}'},
        ),
      );

      if (response.data['success'] == true) {
        final user = response.data['data'];
        _updateLocalData(user);
        StorageService.saveUser(Map<String, dynamic>.from(user));
      }
    } catch (e) {
      print('Profile Error: $e');
      // Fallback to local storage
      _loadFromStorage();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLocalData(Map<String, dynamic> user) {
    name.value = user['name'] ?? 'Patient';
    email.value = user['email'] ?? '';
    mobile.value = user['mobileNo'] ?? '';
    address.value = user['address'] ?? '';
    profileImage.value = user['profileImage'] ?? '';

    // Controllers update
    nameController.text = name.value;
    mobileController.text = mobile.value;
    addressController.text = address.value;

    // DOB format
    try {
      final date = DateTime.parse(user['dob'] ?? '');
      dob.value =
          '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
    } catch (_) {
      dob.value = '';
    }

    // Member since
    try {
      final date = DateTime.parse(user['createdAt'] ?? '');
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      memberSince.value = '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      memberSince.value = '';
    }
  }

  void _loadFromStorage() {
    final user = StorageService.getUser();
    print('Storage User: $user'); // debug
    if (user != null) _updateLocalData(user);
  }

  // ── Reset Edit Fields ──
  void resetProfileFields() {
    nameController.text = name.value;
    mobileController.text = mobile.value;
    addressController.text = address.value;
  }

  // ── Reset Password Fields ──
  void resetPasswordFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  // ── Update Profile ──
  Future<void> updateProfile() async {
    try {
      isUpdating.value = true;

      final response = await _dio.put(
        ApiEndpoints.updateProfile,
        data: {
          'name': nameController.text.trim(),
          'mobileNo': mobileController.text.trim(),
          'address': addressController.text.trim(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${StorageService.getToken()}'},
        ),
      );

      if (response.data['success'] == true) {
        final user = response.data['data'];
        _updateLocalData(user);
        StorageService.saveUser(Map<String, dynamic>.from(user));

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      print('Update Profile Error: ${e.response?.data}');
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

  // ── Upload Profile Photo ──
  Future<void> pickAndUploadPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      isUploadingPhoto.value = true;

      print('Token: ${StorageService.getToken()}');
      print('Image path: ${image.path}');
      print('Image name: ${image.name}');

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      });

      // ← Sirf ek response rakho — duplicate hata diya
      final response = await _dio.put(
        ApiEndpoints.uploadProfilePhoto,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getToken()}',
          },
        ),
      );

      print('Upload Response: ${response.data}');

      if (response.data['success'] == true) {
        final user = response.data['data'];
        _updateLocalData(user);
        StorageService.saveUser(Map<String, dynamic>.from(user));

        Get.snackbar(
          'Success',
          'Profile photo updated!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      print('Upload Photo Error: ${e.response?.data}');
      Get.snackbar(
        'Error',
        'Could not upload photo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ── Change Password ──
  Future<void> changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isChangingPassword.value = true;

      final response = await _dio.put(
        ApiEndpoints.changePassword,
        data: {
          'oldPassword': oldPasswordController.text.trim(),
          'newPassword': newPasswordController.text.trim(),
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${StorageService.getToken()}'},
        ),
      );

      if (response.data['success'] == true) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.back();
        Get.snackbar(
          'Success',
          'Password changed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      print('Change Password Error: ${e.response?.data}');
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
