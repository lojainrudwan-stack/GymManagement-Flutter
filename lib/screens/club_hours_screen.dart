import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

/// Club Hours Screen (شاشة أوقات النادي)
/// Displays the gym's weekly working schedule in an RTL Arabic layout.
/// Accessible from the home tab service card "الاوقات".
class ClubHoursScreen extends StatelessWidget {
  const ClubHoursScreen({super.key});

  // ── Working hours data ──────────────────────────────────────────────────
  static const List<_DayHours> _schedule = [
    _DayHours(day: 'السبت',     open: '06:00 ص', close: '11:00 م', isOpen: true),
    _DayHours(day: 'الأحد',     open: '06:00 ص', close: '11:00 م', isOpen: true),
    _DayHours(day: 'الاثنين',   open: '06:00 ص', close: '11:00 م', isOpen: true),
    _DayHours(day: 'الثلاثاء',  open: '06:00 ص', close: '11:00 م', isOpen: true),
    _DayHours(day: 'الأربعاء',  open: '06:00 ص', close: '11:00 م', isOpen: true),
    _DayHours(day: 'الخميس',    open: '06:00 ص', close: '10:00 م', isOpen: true),
    _DayHours(day: 'الجمعة',    open: '02:00 م', close: '09:00 م', isOpen: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        // ── AppBar ──────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // Force back arrow on the left regardless of locale
          automaticallyImplyLeading: false,
          title: Text(
            'أوقات النادي',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          centerTitle: true,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Info banner ──────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVeryLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.fieldBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ساعات العمل الأسبوعية',
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBrown,
                              ),
                            ),
                            Text(
                              'النادي مفتوح طوال أيام الأسبوع',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section title ────────────────────────────────────────────
                Text(
                  'الجدول الأسبوعي',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBrown,
                  ),
                ),
                const SizedBox(height: 12),

                // ── Schedule cards ───────────────────────────────────────────
                ..._schedule.map((h) => _HoursCard(hours: h)),

                const SizedBox(height: 24),

                // ── Note ─────────────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFE082),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFFF9A825),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'قد تتغير أوقات العمل خلال الأعياد والمناسبات الرسمية.',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: const Color(0xFF6D4C0F),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Contact section ──────────────────────────────────────────
                Text(
                  'تواصل معنا',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBrown,
                  ),
                ),
                const SizedBox(height: 12),

                _ContactRow(
                  icon: Icons.phone_outlined,
                  label: 'الهاتف',
                  value: '+967 71 234 5678',
                ),
                const SizedBox(height: 8),
                _ContactRow(
                  icon: Icons.location_on_outlined,
                  label: 'العنوان',
                  value: 'صنعاء، اليمن',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────
class _DayHours {
  final String day;
  final String open;
  final String close;
  final bool isOpen;
  const _DayHours({
    required this.day,
    required this.open,
    required this.close,
    required this.isOpen,
  });
}

// ── Day hours card ───────────────────────────────────────────────────────────
class _HoursCard extends StatelessWidget {
  final _DayHours hours;
  const _HoursCard({required this.hours});

  // Simple heuristic: highlight today
  bool get _isToday {
    final now = DateTime.now();
    const days = [
      'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء',
      'الخميس', 'الجمعة', 'السبت',
    ];
    return days[now.weekday % 7] == hours.day;
  }

  @override
  Widget build(BuildContext context) {
    final today = _isToday;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: today ? AppColors.primary : AppColors.primaryVeryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: today ? AppColors.primary : AppColors.fieldBorder,
          width: 1,
        ),
        boxShadow: today
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 90,
            child: Text(
              hours.day,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: today ? Colors.white : AppColors.textBrown,
              ),
            ),
          ),

          // Today badge
          if (today)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'اليوم',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const Spacer(),

          // Hours
          if (hours.isOpen) ...[
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: today ? Colors.white70 : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              '${hours.open} – ${hours.close}',
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: today ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ] else
            Text(
              'مغلق',
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: today ? Colors.white70 : Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Contact row ──────────────────────────────────────────────────────────────
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryVeryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
