import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNotificationItem(
            context,
            emoji: '👤',
            iconColor: const Color(0xFF4CAF50),
            title: 'New Followers',
          ),
          _buildNotificationItem(
            context,
            emoji: '💬',
            iconColor: const Color(0xFFFF6B6B),
            title: 'Activities',
          ),
          _buildNotificationItem(
            context,
            emoji: '🔔',
            iconColor: const Color(0xFF4A90E2),
            title: 'System Notifications',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String emoji,
    required Color iconColor,
    required String title,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {
        print('Tapped on $title');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(
                    color: Color(0xFF222222),
                    width: 0.5,
                  ),
                ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}