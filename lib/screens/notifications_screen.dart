import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

/// Notifications Screen (الإشعارات)
/// Matches Reference Image 2.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Notification items structure
  late List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _NotificationItem(
        id: 1,
        group: 'اليوم',
        title: 'تم تجديد اشتراكك بنجاح',
        subtitle: 'قبل ١٠ دقائق',
        icon: Icons.verified_user_outlined,
      ),
      _NotificationItem(
        id: 2,
        group: 'اليوم',
        title: 'تذكير بموعد التمرين',
        subtitle: 'لديك حصة اليوم في النادي الساعة ٦:٠٠ مساءً',
        icon: Icons.fitness_center_rounded,
      ),
      _NotificationItem(
        id: 3,
        group: 'امس',
        title: 'تمت إضافة تمرين جديد',
        subtitle: 'امس ٤:١٥ مساءً',
        icon: Icons.notifications_none_rounded,
      ),
      _NotificationItem(
        id: 4,
        group: 'اقدم',
        title: 'انتهاء الاشتراك قريباً',
        subtitle: 'سينتهي اشتراكك بعد ٥ ايام، يرجى التجديد',
        icon: Icons.info_outline_rounded,
      ),
    ];
  }

  void _dismissNotification(int id) {
    setState(() {
      _notifications.removeWhere((item) => item.id == id);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم مسح جميع الإشعارات',
          style: GoogleFonts.cairo(),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group notifications by group key
    final todayItems = _notifications.where((n) => n.group == 'اليوم').toList();
    final yesterdayItems = _notifications.where((n) => n.group == 'امس').toList();
    final olderItems = _notifications.where((n) => n.group == 'اقدم').toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEBE7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEFEBE7),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'الإشعارات',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          leading: Directionality(
            textDirection: TextDirection.ltr,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textBrown,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _notifications.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد إشعارات حالياً',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (todayItems.isNotEmpty) ...[
                              _buildGroupHeader('اليوم'),
                              ...todayItems.map(_buildNotificationCard),
                              const SizedBox(height: 16),
                            ],
                            if (yesterdayItems.isNotEmpty) ...[
                              _buildGroupHeader('امس'),
                              ...yesterdayItems.map(_buildNotificationCard),
                              const SizedBox(height: 16),
                            ],
                            if (olderItems.isNotEmpty) ...[
                              _buildGroupHeader('اقدم'),
                              ...olderItems.map(_buildNotificationCard),
                              const SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
              ),

              // ── Clear All Notifications Button ───────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: GestureDetector(
                  onTap: _notifications.isEmpty ? null : _clearAllNotifications,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2DAD4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFC7BDB5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.textBrown,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'مسح جميع الاشعارات',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String groupName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 22,
            color: AppColors.textBrown,
          ),
          const SizedBox(width: 6),
          Text(
            groupName,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dismiss 'X' button
          GestureDetector(
            onTap: () => _dismissNotification(item.id),
            child: Icon(
              Icons.close_rounded,
              color: Colors.grey.shade600,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBrown,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      item.icon,
                      size: 20,
                      color: AppColors.textBrown,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final int id;
  final String group;
  final String title;
  final String subtitle;
  final IconData icon;

  const _NotificationItem({
    required this.id,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
