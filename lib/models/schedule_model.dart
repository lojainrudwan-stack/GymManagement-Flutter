/// Model representing a single day in the weekly workout schedule.
class ScheduleDayModel {
  final String dayName;
  final String activity;
  final String time;
  final String period;

  const ScheduleDayModel({
    required this.dayName,
    required this.activity,
    required this.time,
    required this.period,
  });
}

/// Model representing club working hours for a given day.
class ClubHoursModel {
  final String day;
  final String open;
  final String close;
  final bool isOpen;

  const ClubHoursModel({
    required this.day,
    required this.open,
    required this.close,
    required this.isOpen,
  });
}
