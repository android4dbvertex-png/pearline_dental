import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pearline_dental/app/core/theme/app_theme.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ← keyboard dismiss
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ──
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.chevron_left, color: Colors.white),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pearlline Support',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Online',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Message List ──
  Widget _buildMessageList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Connecting to support...',
                style: GoogleFonts.poppins(
                  color: AppColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 56,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start a conversation!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Our support team is here to help you',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isUser = message['senderType'] == 'user';
          final isSending = message['sending'] == true;

          // Show date separator
          bool showDate = false;
          if (index == 0) {
            showDate = true;
          } else {
            final prevDate = DateTime.tryParse(
                controller.messages[index - 1]['createdAt'] ?? '');
            final currDate = DateTime.tryParse(message['createdAt'] ?? '');
            if (prevDate != null && currDate != null) {
              showDate = prevDate.day != currDate.day;
            }
          }

          return Column(
            children: [
              if (showDate) _DateSeparator(dateStr: message['createdAt']),
              _MessageBubble(
                message: message['message'] ?? '',
                isUser: isUser,
                isSending: isSending,
                isRead: message['isRead'] == true ||
                    message['seenByAdmin'] == true, // ← backend field jo bhi ho
                time: _formatTime(message['createdAt'] ?? ''),
              ),
            ],
          );
        },
      );
    });
  }

  // ── Input Bar ──
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text Field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.messageController,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            Obx(() => GestureDetector(
                  onTap: controller.isSending.value
                      ? null
                      : controller.sendMessage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: controller.isSending.value
                          ? AppColors.grey
                          : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: controller.isSending.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour == 0
          ? 12
          : hour > 12
              ? hour - 12
              : hour;
      return '$displayHour:$minute $period';
    } catch (_) {
      return '';
    }
  }
}

// ── Message Bubble ──
class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isSending;
  final bool isRead;
  final String time;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.isSending,
    required this.isRead,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Admin Avatar
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isUser ? Colors.white : AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 4),
                      Icon(
                        isSending
                            ? Icons.access_time_rounded
                            : isRead
                                ? Icons
                                    .done_all_rounded // blue - admin ne dekha
                                : Icons
                                    .done_all_rounded, // grey - delivered, not seen
                        size: 14,
                        color: isSending
                            ? AppColors.grey
                            : isRead
                                ? AppColors.primary
                                : Colors.grey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // User Avatar
          if (isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Date Separator ──
class _DateSeparator extends StatelessWidget {
  final String dateStr;
  const _DateSeparator({required this.dateStr});

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      if (date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return 'Today';
      } else if (date.day == now.day - 1) {
        return 'Yesterday';
      }
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                _formatDate(dateStr),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ],
      ),
    );
  }
}
