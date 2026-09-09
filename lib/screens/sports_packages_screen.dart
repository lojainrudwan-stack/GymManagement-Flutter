import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../services/signalr_service.dart';
import 'payment_methods_screen.dart';

/// Sports Packages Screen (الباقات الرياضية)
/// Matches Reference Image 4.
class SportsPackagesScreen extends StatefulWidget {
  const SportsPackagesScreen({super.key});

  @override
  State<SportsPackagesScreen> createState() => _SportsPackagesScreenState();
}

class _SportsPackagesScreenState extends State<SportsPackagesScreen> {
  int? _selectedPackageIndex;

  List<_SportsPackage> _packages = [
    const _SportsPackage(
      title: 'باقة التدريب الشخصي',
      description: 'مدرب خاص وبرنامج تدريبي يناسب اهداف المشترك',
    ),
    const _SportsPackage(
      title: 'باقة بناء العضلات',
      description: 'برنامج تدريبي مخصص لزيادة الكتلة العضلية',
    ),
    const _SportsPackage(
      title: 'باقة خسارة الوزن',
      description: 'تمارين كارديو ومقاومة متابعة أسبوعية للوزن',
    ),
    const _SportsPackage(
      title: 'باقة الكارديو',
      description: 'أجهزة الجري والدراجات تمارين لرفع اللياقة القلبية',
    ),
    const _SportsPackage(
      title: 'باقة التغذية الرياضية',
      description: 'خطة غذائية ومتابعة مع اخصائي تغذية',
    ),
    const _SportsPackage(
      title: 'باقة الفنون القتالية',
      description: 'تدريبات ملاكمة وبوكسينج تحسين القوة والسرعة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDynamicPackages();

    // Listen for real-time updates from MVC
    SignalRService.instance.onPackageAdded = (_) => _fetchDynamicPackages();
    SignalRService.instance.onPackageUpdated = (_) => _fetchDynamicPackages();
    SignalRService.instance.onPackageDeleted = (_) => _fetchDynamicPackages();
  }

  Future<void> _fetchDynamicPackages() async {
    final plans = await ApiService.instance.fetchSubscriptionPlans();
    if (mounted) {
      setState(() {
        for (var plan in plans) {
          final title = plan['Name'] ?? plan['name'] ?? 'باقة جديدة';
          final desc = plan['Type'] ?? plan['type'] ?? '';
          
          if (!_packages.any((p) => p.title == title)) {
            _packages.add(_SportsPackage(title: title, description: desc));
          }
        }
      });
    }
  }

  void _onContinue() {
    if (_selectedPackageIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'يرجى اختيار باقة رياضية أولاً',
            style: GoogleFonts.cairo(),
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final selected = _packages[_selectedPackageIndex!];

    // Sync selected package with backend
    ApiService.instance.syncSelectedPackage(
      name: selected.title,
      type: 'باقة رياضية',
      durationDays: 30,
      price: 150.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentMethodsScreen(packageTitle: selected.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'الباقات الرياضية',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 2),

              // ── Subtitle ─────────────────────────────────────────────────
              Center(
                child: Text(
                  'اختر مسارك الرياضي لتحقيق هدفك',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: AppColors.textBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Grid of 6 packages ───────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: _packages.length,
                    itemBuilder: (context, index) {
                      final pkg = _packages[index];
                      final isSelected = _selectedPackageIndex == index;
                      return _SportsPackageGridCard(
                        package: pkg,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedPackageIndex = index),
                      );
                    },
                  ),
                ),
              ),

              // ── Continue Button ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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

class _SportsPackage {
  final String title;
  final String description;

  const _SportsPackage({
    required this.title,
    required this.description,
  });
}

class _SportsPackageGridCard extends StatelessWidget {
  final _SportsPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportsPackageGridCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFFAF8F6),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF6B4F42),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              package.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textBrown,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              package.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 11.5,
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
