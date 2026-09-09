import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/user_model.dart';
import 'welcome_screen.dart';
import 'subscriptions_screen.dart';
import 'notifications_screen.dart';

/// Profile Screen (الملف الشخصي)
/// Matches Reference Image 5.
/// Dynamically uses authenticated user data (name, email, phone).
class ProfileScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onBack;
  final void Function(int)? onNavigateTab;

  const ProfileScreen({
    super.key,
    required this.user,
    this.onBack,
    this.onNavigateTab,
  });

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'تسجيل الخروج',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          content: Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            style: GoogleFonts.cairo(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonalData(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'البيانات الشخصية',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBrown,
                ),
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'الاسم:', value: user.name),
              const SizedBox(height: 8),
              _DetailRow(label: 'البريد الإلكتروني:', value: user.email),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'رقم الهاتف:',
                value: user.phone.isNotEmpty ? user.phone : 'غير متوفر',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'الملف الشخصي',
            style: GoogleFonts.cairo(
              fontSize: 22,
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
              onPressed: onBack ?? () => Navigator.maybePop(context),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textBrown,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                // ── User Avatar ──────────────────────────────────────────
                Center(
                  child: Container(
                    width: 120,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(
                        color: const Color(0xFFD4C8C2),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(58),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFFAF7F5),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Dynamic User Name ────────────────────────────────────
                Text(
                  user.name.isNotEmpty ? user.name : 'غيث عبدالله',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBrown,
                  ),
                ),

                // ── Dynamic User Phone / Email ───────────────────────────
                Text(
                  user.phone.isNotEmpty ? user.phone : (user.email.isNotEmpty ? user.email : '+967 77788899'),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: const Color(0xFF5D4037),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Menu Options ─────────────────────────────────────────
                _ProfileMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'البيانات الشخصية',
                  onTap: () => _showPersonalData(context),
                ),
                const SizedBox(height: 12),

                _ProfileMenuItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'الإشتراكات',
                  onTap: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(1); // Go to Subscriptions tab
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SubscriptionsScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),

                _ProfileMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'حجوزاتي',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'قائمة الحجوزات – لا توجد حجوزات حالياً',
                          style: GoogleFonts.cairo(),
                          textDirection: TextDirection.rtl,
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _ProfileMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'الإشعارات',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'صفحة الإعدادات – قريباً',
                          style: GoogleFonts.cairo(),
                          textDirection: TextDirection.rtl,
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _ProfileMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'تسجيل الخروج',
                  isDestructive: true,
                  onTap: () => _onLogout(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4C8C2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isDestructive ? Colors.red.shade700 : const Color(0xFF5D4037),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDestructive ? Colors.red.shade700 : const Color(0xFF5D4037),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textBrown,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
