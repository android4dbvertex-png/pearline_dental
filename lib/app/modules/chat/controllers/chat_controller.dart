import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';
import 'package:pearline_dental/app/core/services/storage_service.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('REQUEST HEADERS: ${options.headers}');
          handler.next(options);
        },
      ),
    );
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final chatId = RxnString();

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    _initChat();
  }

  // ── Init Chat ──
  Future<void> _initChat() async {
    try {
      isLoading.value = true;

      // Check that chatId saved already or not
      final savedChatId = StorageService.getChatId();
      if (savedChatId != null) {
        chatId.value = savedChatId;
        await fetchMessages();
        _startPolling();
        return;
      }

      //  create new chat
      final user = StorageService.getUser();
      final patientName = user?['name'] ??
          user?['email']?.toString().split('@')[0] ??
          'Patient';
      final mobileNo = user?['mobileNo'] ?? '0000000000';

      print('USER = $user');
      print('TOKEN = ${StorageService.getToken()}');
      print('HEADERS = ${_dio.options.headers}');

      final response = await _dio.post(
        ApiEndpoints.chats,
        data: {
          'patientName': patientName,
          'mobileNo': mobileNo,
        },
      );

      print('Chat Response: ${response.data}');

      // extract chatId from response
      final id = response.data['data']?['_id'] ??
          response.data['_id'] ??
          response.data['chatId'];

      if (id != null) {
        chatId.value = id.toString();
        StorageService.saveChatId(id.toString());
        await fetchMessages();
        _startPolling();
      }
    } on DioException catch (e) {
      print('Status Code: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');
      print('Request Data: ${e.requestOptions.data}');
      Get.snackbar(
        'Error',
        'Could not connect to chat. Try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch Messages ──
  Future<void> fetchMessages() async {
    if (chatId.value == null) return;
    try {
      final response = await _dio.get(
        '${ApiEndpoints.messages}/${chatId.value}',
      );

      print('Messages Response: ${response.data}');

      if (response.data['success'] == true) {
        final data = List<Map<String, dynamic>>.from(
          response.data['data'].map((e) => Map<String, dynamic>.from(e)),
        );

        // update if new messages are there
        if (data.length != messages.length) {
          messages.assignAll(data);
          _scrollToBottom();
        }
      }
    } catch (e) {
      print('Fetch Messages Error: $e');
    }
  }

  // ── Send Message ──
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || chatId.value == null) return;

    try {
      isSending.value = true;
      messageController.clear();

      await _dio.post(
        ApiEndpoints.messages,
        data: {
          'chatId': chatId.value,
          'senderType': 'user',
          'message': text,
        },
      );

      // Fetch after API success
      await fetchMessages();
    } on DioException catch (e) {
      print('Send Message Error: ${e.response?.data}');
      Get.snackbar(
        'Error',
        'Message not sent. Try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  // ── Polling ──
  void _startPolling() {
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => fetchMessages(),
    );
  }

  // ── Scroll to Bottom ──
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
