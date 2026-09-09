import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../services/signalr_service.dart';
import 'payment_methods_screen.dart';

/// Subscriptions Screen (الاشتراكات)
/// Matches Reference Image 1.
class SubscriptionsScreen extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const SubscriptionsScreen({
    super.key,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  int _selectedIndex = 2; // Default select 6 months (the most popular)

  List<_SubPackage> _packages = [
    const _SubPackage(
      id: 1,
      title: 'إشتراك شهري',
      price: '100\$',
      bullets: [
        'الوصول الأساسي',
        'الأجهزة الرياضية',
      ],
      icon: Icons.calendar_month_outlined,
      isPopular: false,
    ),
    const _SubPackage(
      id: 2,
      title: 'إشتراك ٣ اشهر',
      price: '250\$',
      bullets: [
        'الوصول الأساسي',
        'الأجهزة الرياضية',
        'خزانة شخصية',
      ],
      icon: Icons.calendar_month_outlined,
      isPopular: false,
    ),
    const _SubPackage(
      id: 3,
      title: 'إشتراك ٦ اشهر',
      price: '400\$',
      bullets: [
        'الوصول الأساسي',
        'الأجهزة الرياضية',
        'خزانة شخصية',
        'تدريب شخصي مجاني لشهر',
      ],
      icon: Icons.military_tech_outlined,
      isPopular: true,
    ),
    const _SubPackage(
      id: 4,
      title: 'إشتراك سنوي',
      price: '1000\$',
      bullets: [
        'الوصول الكامل لجميع خدمات النادي',
        'خصم في مبلغ الاشتراك',
      ],
      icon: Icons.calendar_month_outlined,
      isPopular: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDynamicSubscriptions();

    // Listen for real-time updates from MVC
    SignalRService.instance.onSubscriptionAdded = (_) => _fetchDynamicSubscriptions();
    SignalRService.instance.onSubscriptionUpdated = (_) => _fetchDynamicSubscriptions();
    SignalRService.instance.onSubscriptionDeleted = (_) => _fetchDynamicSubscriptions();
  }

  Future<void> _fetchDynamicSubscriptions() async {
    final plans = await ApiService.instance.fetchSubscriptionPlans();
    if (mounted) {
      setState(() {
        for (var plan in plans) {
          final type = plan['Type'] ?? plan['type'] ?? '';
          if (type != 'اشتراك' && type != 'Subscription') continue; // Only process subscriptions

          final title = plan['Name'] ?? plan['name'] ?? 'اشتراك جديد';
          final priceVal = plan['Price'] ?? plan['price'] ?? 0;
          final priceStr = '${priceVal}\$';
          final durationDays = plan['DurationDays'] ?? plan['durationDays'] ?? 30;
          
          if (!_packages.any((p) => p.title == title)) {
            _packages.add(_SubPackage(
              id: durationDays,
              title: title,
              price: priceStr,
              bullets: const ['الوصول الأساسي', 'الأجهزة الرياضية'], // default features
              icon: Icons.calendar_month_outlined,
              isPopular: false,
            ));
          }
        }
      });
    }
  }

  void _onSubscribe() {
    final selected = _packages[_selectedIndex];

    // Extract price number from string (e.g. '100$' -> 100.0)
    final priceNum = double.tryParse(selected.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 100.0;
    
    int days;
    if (selected.id == 1) days = 30;
    else if (selected.id == 2) days = 90;
    else if (selected.id == 3) days = 180;
    else if (selected.id == 4) days = 365;
    else days = selected.id;

    // Sync selected package to backend
    ApiService.instance.syncSelectedPackage(
      name: selected.title,
      type: 'اشتراك',
      durationDays: days,
      price: priceNum,
    );

    // Sync selected subscription type to MVC Subscriptions
    ApiService.instance.syncSelectedSubscriptionType(
      title: selected.title,
      durationDays: days,
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
            'الاشتراكات',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          leading: (widget.showBackButton || widget.onBack != null || Navigator.canPop(context))
              ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textBrown,
                      size: 20,
                    ),
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else if (Navigator.canPop(context)) {
                        Navigator.maybePop(context);
                      }
                    },
                  ),
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── Packages List ────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  itemCount: _packages.length,
                  itemBuilder: (context, index) {
                    final item = _packages[index];
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFF8D7B68),
                                width: isSelected ? 2.5 : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Card Header: Price (Left) + Title & Icon (Right in RTL)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Title + Icon
                                    Row(
                                      children: [
                                        Icon(
                                          item.icon,
                                          size: 28,
                                          color: AppColors.textBrown,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          item.title,
                                          style: GoogleFonts.cairo(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textBrown,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Price
                                    Text(
                                      item.price,
                                      style: GoogleFonts.cairo(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF7D6E66),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // ── Bullet Points ────────────────────────────
                                ...item.bullets.map(
                                  (bullet) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4, right: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF5D4037),
                                            shape: BoxShape.rectangle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          bullet,
                                          style: GoogleFonts.cairo(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF5D4037),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── "الأكثر طلباً" Badge for Card 3 ───────────────
                          if (item.isPopular)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Transform.rotate(
                                angle: -0.4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCD4CD),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFF8D7B68),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'الأكثر طلباً',
                                    style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBrown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Subscribe Button ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onSubscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'الاشتراك',
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

class _SubPackage {
  final int id;
  final String title;
  final String price;
  final List<String> bullets;
  final IconData icon;
  final bool isPopular;

  const _SubPackage({
    required this.id,
    required this.title,
    required this.price,
    required this.bullets,
    required this.icon,
    required this.isPopular,
  });
}
