import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'trainers_list_screen.dart';

/// Trainer Gender / Category Selection Screen (إختر نوع الإشتراك)
/// Matches Reference Image 3.
class TrainerGenderScreen extends StatefulWidget {
  const TrainerGenderScreen({super.key});

  @override
  State<TrainerGenderScreen> createState() => _TrainerGenderScreenState();
}

class _TrainerGenderScreenState extends State<TrainerGenderScreen> {
  String _selectedCategory = 'female'; // 'female' or 'male'

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainersListScreen(gender: _selectedCategory),
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
            'إختر نوع الإشتراك',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 4),

              // ── Subtitle ─────────────────────────────────────────────────
              Center(
                child: Text(
                  'اختر فئة الإشتراك المناسبة لك',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Selection Cards (Women / Men) ────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // ── Women Card ───────────────────────────────────────
                      _CategoryCard(
                        title: 'النساء',
                        desc1: 'تدرب النساء على يد مدربات نساء',
                        desc2: 'جميع الحصص والإشراف في منطقة مخصصة للنساء فقط',
                        imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=300&auto=format&fit=crop&q=80',
                        fallbackIcon: Icons.fitness_center_rounded,
                        isSelected: _selectedCategory == 'female',
                        onTap: () => setState(() => _selectedCategory = 'female'),
                      ),

                      const SizedBox(height: 16),

                      // ── Men Card ─────────────────────────────────────────
                      _CategoryCard(
                        title: 'الرجال',
                        desc1: 'يدرب الرجال على يد مدربين رجال',
                        desc2: 'جميع الحصص و الإشراف في منطقة مخصصة للرجال فقط',
                        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=300&auto=format&fit=crop&q=80',
                        fallbackIcon: Icons.sports_gymnastics_rounded,
                        isSelected: _selectedCategory == 'male',
                        onTap: () => setState(() => _selectedCategory = 'male'),
                      ),

                      const SizedBox(height: 20),

                      // ── Privacy & Security Box ───────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFD4C8C2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.textBrown,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'تضمن لك الخصوصية والراحة يتم تخصيص المدربين والمناطق حسب نوع الإشتراك',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: AppColors.textBrown,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // ── Continue Button ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'متابعة',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card (Women / Men)
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final String title;
  final String desc1;
  final String desc2;
  final String imageUrl;
  final IconData fallbackIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.desc1,
    required this.desc2,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFD4C8C2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar / Workout circle illustration
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 90,
                    height: 90,
                    color: const Color(0xFFE5DDD6),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        fallbackIcon,
                        size: 40,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Title and descriptions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBrown,
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc1,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              desc2,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF5D4037),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
