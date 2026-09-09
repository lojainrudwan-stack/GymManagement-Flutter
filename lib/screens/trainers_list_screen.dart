import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/trainer_model.dart';
import '../services/api_service.dart';
import '../services/signalr_service.dart';

/// Trainers List Screen (قائمة المدربين / المدربات)
/// Matches Reference Images 1 and 2.
class TrainersListScreen extends StatefulWidget {
  final String gender; // 'male' or 'female'

  const TrainersListScreen({super.key, required this.gender});

  @override
  State<TrainersListScreen> createState() => _TrainersListScreenState();
}

class _TrainersListScreenState extends State<TrainersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedTrainerId;
  String _searchQuery = '';

  List<TrainerModel> _maleTrainers = [
    const TrainerModel(
      id: 1,
      title: 'المدرب ١',
      name: 'خالد عبدالله',
      specialty: 'التخصص: تمارين القوة واللياقة العامة',
      experienceYears: 6,
      trainingHours: 'أوقات التدريب: ٤:٠٠ م - ١٠:٠٠ م',
      rating: 3,
      gender: 'male',
      imageUrl: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 2,
      title: 'المدرب ٢',
      name: 'يوسف محمد',
      specialty: 'التخصص: إنقاص الوزن',
      experienceYears: 9,
      trainingHours: 'أوقات التدريب: ٣:٠٠ م - ٨:٠٠ م',
      rating: 5,
      gender: 'male',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 3,
      title: 'المدرب ٣',
      name: 'سلطان احمد',
      specialty: 'التخصص: تضخيم وكمال الأجسام',
      experienceYears: 7,
      trainingHours: 'أوقات التدريب: ٤:٠٠ م - ١١:٠٠ م',
      rating: 4,
      gender: 'male',
      imageUrl: 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 4,
      title: 'المدرب ٤',
      name: 'ليث مازن',
      specialty: 'التخصص: التدريب الوظيفي والمرونة',
      experienceYears: 5,
      trainingHours: 'أوقات التدريب: ٥:٠٠ م - ١١:٠٠ م',
      rating: 3,
      gender: 'male',
      imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300&auto=format&fit=crop&q=80',
    ),
  ];

  List<TrainerModel> _femaleTrainers = [
    const TrainerModel(
      id: 101,
      title: 'المدربة ١',
      name: 'سارة احمد',
      specialty: 'التخصص: اللياقة البدنية',
      experienceYears: 5,
      trainingHours: 'أوقات التدريب: ٣:٠٠ م - ٨:٠٠ م',
      rating: 3,
      gender: 'female',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 102,
      title: 'المدربة ٢',
      name: 'نورة خالد',
      specialty: 'التخصص: إنقاص الوزن',
      experienceYears: 6,
      trainingHours: 'أوقات التدريب: ٢:٠٠ م - ٦:٠٠ م',
      rating: 3,
      gender: 'female',
      imageUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 103,
      title: 'المدربة ٣',
      name: 'يارا يوسف',
      specialty: 'التخصص: اليوغا وتمارين المرونة',
      experienceYears: 4,
      trainingHours: 'أوقات التدريب: ٩:٠٠ ص - ١٢:٠٠ م',
      rating: 3,
      gender: 'female',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
    ),
    const TrainerModel(
      id: 104,
      title: 'المدربة ٤',
      name: 'تالين كنان',
      specialty: 'التخصص: اللياقة العامة وتقوية العضلات',
      experienceYears: 7,
      trainingHours: 'أوقات التدريب: ٢:٠٠ م - ٧:٠٠ م',
      rating: 4,
      gender: 'female',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchDynamicTrainers();

    // Listen for real-time updates from MVC
    SignalRService.instance.onTrainerAdded = (_) => _fetchDynamicTrainers();
    SignalRService.instance.onTrainerUpdated = (_) => _fetchDynamicTrainers();
    SignalRService.instance.onTrainerDeleted = (_) => _fetchDynamicTrainers();
    // Reconnect handling
    SignalRService.instance.onReconnected = () => _fetchDynamicTrainers();
  }

  Future<void> _fetchDynamicTrainers() async {
    final coaches = await ApiService.instance.fetchCoaches();
    if (mounted) {
      setState(() {
        for (var coach in coaches) {
          final idRaw = coach['Id'] ?? coach['id'] ?? DateTime.now().millisecondsSinceEpoch;
          final name = coach['Name'] ?? coach['name'] ?? 'مدرب جديد';
          final spec = coach['Specialization'] ?? coach['specialization'] ?? 'تدريب عام';
          final phone = coach['Phone'] ?? coach['phone'] ?? 'غير محدد';
          final coachGender = coach['Gender'] ?? coach['gender'] ?? widget.gender; // Use current screen gender as fallback if API lacks it
          
          final newTrainer = TrainerModel(
            id: idRaw is int ? idRaw : int.tryParse(idRaw.toString()) ?? 999,
            name: name,
            title: coachGender == 'female' ? 'مدربة' : 'مدرب',
            specialty: spec,
            experienceYears: 1,
            trainingHours: phone,
            rating: 5.0,
            gender: coachGender,
          );

          if (coachGender == 'female') {
            if (!_femaleTrainers.any((t) => t.name == name)) {
              _femaleTrainers.add(newTrainer);
            }
          } else {
            if (!_maleTrainers.any((t) => t.name == name)) {
              _maleTrainers.add(newTrainer);
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TrainerModel> get _currentList {
    final list = widget.gender == 'female' ? _femaleTrainers : _maleTrainers;
    if (_searchQuery.trim().isEmpty) return list;
    return list.where((t) {
      return t.name.contains(_searchQuery) ||
          t.specialty.contains(_searchQuery) ||
          t.title.contains(_searchQuery);
    }).toList();
  }

  void _onSelectTrainer(TrainerModel trainer) {
    setState(() {
      _selectedTrainerId = trainer.id;
    });
  }

  void _onContinue() {
    if (_selectedTrainerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.gender == 'female'
                ? 'يرجى اختيار مدربة أولاً'
                : 'يرجى اختيار مدرب أولاً',
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

    final selected = _currentList.firstWhere(
      (t) => t.id == _selectedTrainerId,
      orElse: () => _currentList.first,
    );

    // Save and sync selected trainer with backend
    ApiService.instance.syncSelectedTrainer(selected);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم اختيار ${selected.name} بنجاح! تم حفظ الاختيار.',
          style: GoogleFonts.cairo(),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Return the selected trainer back to caller or navigate back to Home
    Navigator.pop(context, selected);
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = widget.gender == 'female';
    final title = isFemale ? 'المدربات' : 'المدربون';

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
            title,
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
            children: [
              // ── Search bar ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEEB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'بحث',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: GoogleFonts.cairo(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Trainers List ────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: _currentList.length,
                  itemBuilder: (context, index) {
                    final trainer = _currentList[index];
                    final isSelected = _selectedTrainerId == trainer.id;
                    return _TrainerCard(
                      trainer: trainer,
                      isSelected: isSelected,
                      onTap: () => _onSelectTrainer(trainer),
                    );
                  },
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

// ─────────────────────────────────────────────────────────────────────────────
// Trainer Card Component
// ─────────────────────────────────────────────────────────────────────────────
class _TrainerCard extends StatelessWidget {
  final TrainerModel trainer;
  final bool isSelected;
  final VoidCallback onTap;

  const _TrainerCard({
    required this.trainer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Trainer Image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 75,
                height: 95,
                color: const Color(0xFFF3EEEB),
                child: trainer.imageUrl != null
                    ? Image.network(
                        trainer.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildFallbackIcon(),
                      )
                    : _buildFallbackIcon(),
              ),
            ),

            const SizedBox(width: 12),

            // ── Trainer Details ────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${trainer.title} : ${trainer.name}',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBrown,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Specialty
                  Text(
                    trainer.specialty,
                    style: GoogleFonts.cairo(
                      fontSize: 11.5,
                      color: const Color(0xFF5D4037),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Experience
                  Text(
                    'الخبرة: ${trainer.experienceYears} سنوات',
                    style: GoogleFonts.cairo(
                      fontSize: 11.5,
                      color: const Color(0xFF5D4037),
                    ),
                  ),

                  // Hours
                  Text(
                    trainer.trainingHours,
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: const Color(0xFF5D4037),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Rating Stars
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < trainer.rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: const Color(0xFFE5B842),
                        size: 18,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        trainer.gender == 'female'
            ? Icons.face_3_rounded
            : Icons.person_rounded,
        size: 40,
        color: AppColors.primaryLight,
      ),
    );
  }
}
