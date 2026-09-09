enum PaymentStatus { paid, pending, cancelled }

/// Model representing a payment history record.
class PaymentRecordModel {
  final String id;
  final String description;
  final double amount;
  final String date;
  final PaymentStatus status;

  const PaymentRecordModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });
}
