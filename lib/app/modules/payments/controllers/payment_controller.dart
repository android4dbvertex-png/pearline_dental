import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';
import 'package:pearline_dental/app/routes/app_routes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/payment_request_model.dart';

class PaymentController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  final amountController = TextEditingController();
  late Razorpay _razorpay;

  final isLoading = false.obs;
  final payments = <Map<String, dynamic>>[].obs;
  final isLoadingPayments = false.obs;
  final paymentRequests = <PaymentRequestModel>[].obs;
  final isLoadingRequests = false.obs;

  @override
  void onInit() {
    super.onInit();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    fetchPaymentRequests();
    fetchMyPayments();
  }

  // ── Create Order ──
  Future<void> createOrder(PaymentRequestModel request) async {
    try {
      isLoading.value = true;

      final response = await _dio.post(
        ApiEndpoints.createOrder,
        data: {
          "paymentRequestId": request.id,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${StorageService.getToken()}",
          },
        ),
      );

      print(response.data);

      if (response.data["success"] == true) {
        final order = response.data["order"];
        final user = StorageService.getUser();

        var options = {
          "key": "rzp_test_T4f3bSHfBsud8K",
          "amount": order["amount"],
          "order_id": order["id"],
          "currency": order["currency"],
          "name": "Pearlline Dental",
          "description": request.title,
          "prefill": {
            "name": user?["name"] ?? "",
            "email": user?["email"] ?? "",
            "contact": user?["mobileNo"] ?? "",
          }
        };

        _razorpay.open(options);
      }
    } on DioException catch (e) {
      print(e.response?.data);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Create Order Manually (custom amount) ──
  // ── Create Order Manually (custom amount) ──
  Future<void> createManualOrder() async {
    final amountText = amountController.text.trim();

    if (amountText.isEmpty) {
      Get.snackbar(
        'Enter Amount',
        'Please enter an amount to pay',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _dio.post(
        ApiEndpoints.createCustomOrder,
        data: {
          "amount": amount,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${StorageService.getToken()}",
          },
        ),
      );

      print(response.data);

      if (response.data["success"] == true) {
        final order = response.data["order"];
        final user = StorageService.getUser();

        var options = {
          "key": "rzp_test_T4f3bSHfBsud8K",
          "amount": order["amount"],
          "order_id": order["id"],
          "currency": order["currency"],
          "name": "Pearlline Dental",
          "description": "Manual Payment",
          "prefill": {
            "name": user?["name"] ?? "",
            "email": user?["email"] ?? "",
            "contact": user?["mobileNo"] ?? "",
          }
        };

        _razorpay.open(options);
      }
    } on DioException catch (e) {
      print(e.response?.data);
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to create order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch My Payments ──
  Future<void> fetchPaymentRequests() async {
    try {
      isLoadingRequests.value = true;
      const url = '${ApiEndpoints.baseUrl}${ApiEndpoints.myPaymentRequests}';

      print("FULL URL: $url");
      print("TOKEN: ${StorageService.getToken()}");

      final response = await _dio.get(
        ApiEndpoints.myPaymentRequests,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getToken()}',
          },
        ),
      );

      if (response.data['success'] == true) {
        paymentRequests.assignAll(
          (response.data['data'] as List)
              .map((e) => PaymentRequestModel.fromJson(e))
              .toList(),
        );
      }
    } on DioException catch (e) {
      print("Payment Requests Error: ${e.response?.data}");
    } catch (e) {
      print("Payment Requests Error: $e");
    } finally {
      isLoadingRequests.value = false;
    }
  }

   // fetch my payments

  Future<void> fetchMyPayments() async {
    try {
      isLoadingPayments.value = true;

      final response = await _dio.get(
        ApiEndpoints.myPayments,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StorageService.getToken()}',
          },
        ),
      );

      print('My Payments Response: ${response.data}');

      if (response.data['success'] == true) {
        payments.value = List<Map<String, dynamic>>.from(
          response.data['payments']
              .map((e) => Map<String, dynamic>.from(e)),
        );
      }
    } catch (e) {
      print('Fetch Payments Error: $e');
    } finally {
      isLoadingPayments.value = false;
    }
  }

  // ── Payment Handlers ──
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    Get.snackbar(
      'Payment Successful! 🎉',
      'Payment ID: ${response.paymentId}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
    amountController.clear();
    fetchMyPayments();
    fetchPaymentRequests();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.message}');
    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment was not completed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  void goToMyPayments() => Get.toNamed(AppRoutes.myPayments);

  @override
  void onClose() {
    _razorpay.clear();
    amountController.dispose();
    super.onClose();
  }
}
