import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController     = TextEditingController();
  final _phoneController    = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();

  bool _obscurePass    = true;
  bool _obscureConfirm = false;
  String? _selectedGender; // 'male' | 'female'
  bool _acceptedTerms  = false;
  bool _isLoading      = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Validation helpers ────────────────────────────────────────────────────
  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
    final ok = RegExp(r'^[\w.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+$').hasMatch(v.trim());
    return ok ? null : 'بريد إلكتروني غير صحيح';
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
    if (v.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'هذا الحقل مطلوب';
    if (v != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  // ── Register action ───────────────────────────────────────────────────────
  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      _showError('يرجى اختيار الجنس');
      return;
    }
    if (!_acceptedTerms) {
      _showError('يرجى الموافقة على الشروط والأحكام');
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.instance.register(
      name:     _nameController.text.trim(),
      phone:    _phoneController.text.trim(),
      email:    _emailController.text.trim(),
      password: _passwordController.text,
      gender:   _selectedGender!,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen(user: result.data!)),
        (route) => false,
      );
    } else {
      _showError(result.error ?? 'حدث خطأ أثناء التسجيل');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.cairo(), textDirection: TextDirection.rtl),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Corner triangle decorations
          Positioned(
            top: 0, right: 0,
            child: ClipPath(
              clipper: _CornerClipper(topRight: true),
              child: Container(width: 90, height: 90, color: AppColors.primaryLight),
            ),
          ),
          Positioned(
            bottom: 0, left: 0,
            child: ClipPath(
              clipper: _CornerClipper(topRight: false),
              child: Container(width: 90, height: 90, color: AppColors.primaryLight),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar ─────────────────────────────────────────────
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.black54, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'إنشاء حساب',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.bold,
                              color: AppColors.textBrown,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),

                // ── Form ────────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),

                          // Full name
                          _buildField(
                            controller: _nameController,
                            hint: 'الاسم كامل',
                            icon: Icons.person_outline_rounded,
                            validator: _required,
                          ),
                          const SizedBox(height: 12),

                          // Phone
                          _buildField(
                            controller: _phoneController,
                            hint: 'رقم الجوال',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: _required,
                          ),
                          const SizedBox(height: 12),

                          // Email
                          _buildField(
                            controller: _emailController,
                            hint: 'البريد الإلكتروني',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 12),

                          // Password
                          _buildField(
                            controller: _passwordController,
                            hint: 'كلمة المرور',
                            icon: _obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            obscureText: _obscurePass,
                            validator: _validatePassword,
                            onIconTap: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                          const SizedBox(height: 12),

                          // Confirm password
                          _buildField(
                            controller: _confirmController,
                            hint: 'تأكيد كلمة المرور',
                            icon: _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            obscureText: _obscureConfirm,
                            validator: _validateConfirm,
                            onIconTap: () =>
                                setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                          const SizedBox(height: 16),

                          // ── Gender ──────────────────────────────────────
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              'الجنس',
                              style: GoogleFonts.cairo(
                                fontSize: 16, fontWeight: FontWeight.bold,
                                color: AppColors.textBrown,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _genderButton('ذكر',   'male')),
                              const SizedBox(width: 12),
                              Expanded(child: _genderButton('أنثى', 'female')),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ── Terms checkbox ──────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  'أوافق على الشروط والأحكام',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14, color: AppColors.textBrown,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Checkbox(
                                value: _acceptedTerms,
                                onChanged: (v) =>
                                    setState(() => _acceptedTerms = v ?? false),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                side: const BorderSide(
                                    color: AppColors.primary, width: 1.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Register button ─────────────────────────────
                          SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24, height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : Text(
                                      'تسجيل الدخول',
                                      style: GoogleFonts.cairo(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Already have account ────────────────────────
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                );
                              },
                              child: RichText(
                                textDirection: TextDirection.rtl,
                                text: TextSpan(
                                  style: GoogleFonts.cairo(
                                      fontSize: 14, color: Colors.black54),
                                  children: [
                                    const TextSpan(text: 'لديك حساب بالفعل؟ '),
                                    TextSpan(
                                      text: 'تسجيل الدخول',
                                      style: GoogleFonts.cairo(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Gender toggle button ────────────────────────────────────────────────
  Widget _genderButton(String label, String value) {
    final selected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryVeryLight : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.fieldBorder,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? AppColors.primary : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  // ── Field builder ───────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    VoidCallback? onIconTap,
  }) {
    final iconWidget = onIconTap != null
        ? GestureDetector(
            onTap: onIconTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: AppColors.iconGrey, size: 22),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: AppColors.iconGrey, size: 22),
          );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      validator: validator,
      style: GoogleFonts.cairo(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: GoogleFonts.cairo(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: iconWidget,
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        errorStyle: GoogleFonts.cairo(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

// ── Corner clipper ──────────────────────────────────────────────────────────
class _CornerClipper extends CustomClipper<Path> {
  final bool topRight;
  const _CornerClipper({required this.topRight});

  @override
  Path getClip(Size s) {
    final p = Path();
    if (topRight) {
      p.moveTo(s.width, 0);
      p.lineTo(0, 0);
      p.lineTo(s.width, s.height);
    } else {
      p.moveTo(0, s.height);
      p.lineTo(s.width, s.height);
      p.lineTo(0, 0);
    }
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> o) => false;
}
