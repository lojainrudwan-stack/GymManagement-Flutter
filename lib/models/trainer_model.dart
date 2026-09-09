class TrainerModel {
  final int id;
  final String name;
  final String title; // e.g. "المدرب 1" or "المدربة 1"
  final String specialty;
  final int experienceYears;
  final String trainingHours;
  final double rating; // 1 to 5 stars
  final String gender; // 'male' | 'female'
  final String? imageUrl;

  const TrainerModel({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.experienceYears,
    required this.trainingHours,
    required this.rating,
    required this.gender,
    this.imageUrl,
  });
}
