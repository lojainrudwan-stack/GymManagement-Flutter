import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

/// Payment Screen (شاشة الدفع)
/// Shown as the third tab in the home bottom navigation bar.
/// Displays payment methods and recent payment history in RTL Arabic.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // 0 = طرق الدفع, 1 = السجل
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Payment history (mock) ──────────────────────────────────────────────
  static const List<_PaymentRecord> _history = [
    _PaymentRecord(
      id: '#INV-0042',
      description: 'الباقة الشهرية',
      amount: 30,
      date: '2026-08-01',
      status: _PayStatus.paid,
    ),
    _PaymentRecord(
      id: '#INV-0031',
      description: 'الباقة الشهرية',
      amount: 30,
      date: '2026-07-01',
      status: _PayStatus.paid,
    ),
    _PaymentRecord(
      id: '#INV-0019',
      description: 'الباقة الربعسنوية',
      amount: 80,
      date: '2026-04-01',
      status: _PayStatus.paid,
    ),
    _PaymentRecord(
      id: '#INV-0008',
      description: 'اشتراك تجريبي',
      amount: 15,
      date: '2026-01-10',
      status: _PayStatus.cancelled,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الدفع',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBrown,
                    ),
                  ),
                  Text(
                    'إدارة طرق الدفع وسجل المدفوعات',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryVeryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textBrown,
                  dividerColor: Colors.transparent,
                  labelStyle: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.cairo(fontSize: 14),
                  tabs: const [
                    Tab(text: 'طرق الدفع'),
                    Tab(text: 'السجل'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab content ───────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PaymentMethodsTab(onAdd: _onAddMethod),
                  _PaymentHistoryTab(records: _history),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddMethod() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddPaymentMethodSheet(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT METHODS TAB
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodsTab extends StatelessWidget {
  final VoidCallback onAdd;
  const _PaymentMethodsTab({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Saved card (mock) ──────────────────────────────────────────
          _SavedCard(
            lastFour: '4242',
            cardType: 'Visa',
            expiry: '08/27',
            isDefault: true,
            onRemove: () {},
          ),

          const SizedBox(height: 12),

          // ── Add new method ─────────────────────────────────────────────
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.fieldBorder,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryVeryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'إضافة طريقة دفع جديدة',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBrown,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Accepted methods row ───────────────────────────────────────
          Text(
            'طرق الدفع المقبولة',
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textBrown,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Visa', 'Mastercard', 'Mada', 'Apple Pay'].map(
              (m) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryVeryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: Text(
                  m,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBrown,
                  ),
                ),
              ),
            ).toList(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT HISTORY TAB
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentHistoryTab extends StatelessWidget {
  final List<_PaymentRecord> records;
  const _PaymentHistoryTab({required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مدفوعات حتى الآن',
          style: GoogleFonts.cairo(color: Colors.grey.shade500, fontSize: 15),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _HistoryTile(record: records[i]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Saved card widget
// ─────────────────────────────────────────────────────────────────────────────
class _SavedCard extends StatelessWidget {
  final String lastFour;
  final String cardType;
  final String expiry;
  final bool isDefault;
  final VoidCallback onRemove;

  const _SavedCard({
    required this.lastFour,
    required this.cardType,
    required this.expiry,
    required this.isDefault,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: card type + default badge
          Row(
            children: [
              Text(
                cardType,
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              if (isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'افتراضي',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Card number
          Text(
            '**** **** **** $lastFour',
            style: GoogleFonts.robotoMono(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 16),

          // Expiry
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تاريخ الانتهاء',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    expiry,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// History tile
// ─────────────────────────────────────────────────────────────────────────────
enum _PayStatus { paid, pending, cancelled }

class _PaymentRecord {
  final String id;
  final String description;
  final double amount;
  final String date;
  final _PayStatus status;

  const _PaymentRecord({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class _HistoryTile extends StatelessWidget {
  final _PaymentRecord record;
  const _HistoryTile({required this.record});

  Color get _statusColor {
    switch (record.status) {
      case _PayStatus.paid:
        return const Color(0xFF388E3C);
      case _PayStatus.pending:
        return const Color(0xFFF57C00);
      case _PayStatus.cancelled:
        return const Color(0xFFD32F2F);
    }
  }

  String get _statusLabel {
    switch (record.status) {
      case _PayStatus.paid:
        return 'مدفوعة';
      case _PayStatus.pending:
        return 'معلقة';
      case _PayStatus.cancelled:
        return 'ملغاة';
    }
  }

  IconData get _statusIcon {
    switch (record.status) {
      case _PayStatus.paid:
        return Icons.check_circle_outline_rounded;
      case _PayStatus.pending:
        return Icons.schedule_rounded;
      case _PayStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 22),
          ),
          const SizedBox(width: 12),

          // Description + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.description,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBrown,
                  ),
                ),
                Text(
                  '${record.id}  •  ${record.date}',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // Amount + status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${record.amount.toStringAsFixed(0)}',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBrown,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: _statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet – Add payment method
// ─────────────────────────────────────────────────────────────────────────────
class _AddPaymentMethodSheet extends StatefulWidget {
  const _AddPaymentMethodSheet();

  @override
  State<_AddPaymentMethodSheet> createState() =>
      _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState extends State<_AddPaymentMethodSheet> {
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(
          24, 20, 24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
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
              const SizedBox(height: 20),

              Text(
                'إضافة بطاقة جديدة',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBrown,
                ),
              ),
              const SizedBox(height: 20),

              // Card fields
              _SheetField(
                controller: _nameCtrl,
                hint: 'الاسم على البطاقة',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 12),
              _SheetField(
                controller: _cardNumberCtrl,
                hint: 'رقم البطاقة',
                icon: Icons.credit_card_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SheetField(
                      controller: _expiryCtrl,
                      hint: 'MM/YY',
                      icon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SheetField(
                      controller: _cvvCtrl,
                      hint: 'CVV',
                      icon: Icons.lock_outline_rounded,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إضافة البطاقة بنجاح',
                          style: GoogleFonts.cairo(),
                          textDirection: TextDirection.rtl,
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'حفظ البطاقة',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;

  const _SheetField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: GoogleFonts.cairo(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle:
            GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 20),
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.fieldBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.fieldBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
