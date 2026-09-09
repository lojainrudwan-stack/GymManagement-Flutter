import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

/// Sports Schedule Screen (جدولك الرياضي لهذا الاسبوع)
/// Matches Reference Image 4.
class SportsScheduleScreen extends StatelessWidget {
  const SportsScheduleScreen({super.key});

  static const List<_ScheduleDay> _days = [
    _ScheduleDay(
      dayName: 'السبت',
      activity: 'جسم\nكامل',
      time: '11:00',
      period: 'صباحاً',
    ),
    _ScheduleDay(
      dayName: 'الاحد',
      activity: 'صدر\nوذراعين',
      time: '9:00',
      period: 'صباحاً',
    ),
    _ScheduleDay(
      dayName: 'الاثنين',
      activity: 'كارديو\nجري',
      time: '7:00',
      period: 'صباحاً',
    ),
    _ScheduleDay(
      dayName: 'الثلاثاء',
      activity: 'نشاط\nكامل',
      time: '7:00',
      period: 'مساءً',
    ),
    _ScheduleDay(
      dayName: 'الاربعاء',
      activity: 'رفع\nاثقال',
      time: '10:00',
      period: 'صباحاً',
    ),
    _ScheduleDay(
      dayName: 'الخميس',
      activity: 'نشاط\nخفيف',
      time: '10:00',
      period: 'مساءً',
    ),
  ];

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
            'جدولك الرياضي لهذا الاسبوع',
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Section Title ──────────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تمارين هذا الأسبوع',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBrown,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ── Progress Bar 2/7 ───────────────────────────────────────
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Text(
                        '2/7',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBrown,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 10,
                            color: Colors.grey.shade200,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 2 / 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ── Grid Container with Beige Background ───────────────────
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCD4CD),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.88,
                      ),
                      itemCount: _days.length,
                      itemBuilder: (context, index) {
                        final item = _days[index];
                        return _DayScheduleCard(day: item);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleDay {
  final String dayName;
  final String activity;
  final String time;
  final String period;

  const _ScheduleDay({
    required this.dayName,
    required this.activity,
    required this.time,
    required this.period,
  });
}

class _DayScheduleCard extends StatelessWidget {
  final _ScheduleDay day;

  const _DayScheduleCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day Name
          Text(
            day.dayName,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          const SizedBox(height: 2),

          // Workout focus
          Text(
            day.activity,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textBrown,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),

          // Time & Period
          Text(
            day.time,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          Text(
            day.period,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textBrown,
            ),
          ),
        ],
      ),
    );
  }
}
