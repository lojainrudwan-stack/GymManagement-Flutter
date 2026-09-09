import 'package:flutter/material.dart';

/// Model representing a gym subscription tier/package (باقة اشتراك).
class SubscriptionPackageModel {
  final int id;
  final String title;
  final String price;
  final List<String> bullets;
  final IconData icon;
  final bool isPopular;

  const SubscriptionPackageModel({
    required this.id,
    required this.title,
    required this.price,
    required this.bullets,
    required this.icon,
    required this.isPopular,
  });
}
