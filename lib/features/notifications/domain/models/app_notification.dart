
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';

enum NotificationType {
  medical,
  insurance,
  document,
  safety,
  general
}

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final NotificationType type;
  final DateTime date;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.date,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.medical:
        return Iconsax.health;
      case NotificationType.insurance:
        return Iconsax.shield_tick;
      case NotificationType.document:
        return Iconsax.document;
      case NotificationType.safety:
        return Iconsax.warning_2;
      case NotificationType.general:
        return Iconsax.notification;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.medical:
        return AppColors.success;
      case NotificationType.insurance:
        return AppColors.error;
      case NotificationType.document:
        return AppColors.info;
      case NotificationType.safety:
        return AppColors.warning;
      case NotificationType.general:
        return AppColors.primary;
    }
  }
}
