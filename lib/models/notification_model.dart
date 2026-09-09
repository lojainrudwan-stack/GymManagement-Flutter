import 'package:flutter/material.dart';

/// Model representing an in-app notification item (إشعار).
class NotificationModel {
  final int id;
  final String group; // 'اليوم', 'امس', 'اقدم'
  final String title;
  final String subtitle;
  final IconData icon;

  const NotificationModel({
    required this.id,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
