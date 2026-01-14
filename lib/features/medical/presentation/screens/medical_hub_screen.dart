import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class MedicalHubScreen extends ConsumerWidget {
  const MedicalHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Medical Hub'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {
              // TODO: Add new record
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        children: [
          // Categories - NO Emergency ID here (lock screen only)
          Row(
            children: [
              Expanded(
                child: _CategoryCard(
                  icon: Iconsax.document_text,
                  title: 'Records',
                  count: '12',
                  color: AppColors.info,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: _CategoryCard(
                  icon: Iconsax.health,
                  title: 'Medications',
                  count: '5',
                  color: AppColors.success,
                  onTap: () {},
                ),
              ),
            ],
          )
              .animate(delay: 50.ms)
              .slideX(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          const SizedBox(height: AppTheme.spaceSm),

          Row(
            children: [
              Expanded(
                child: _CategoryCard(
                  icon: Iconsax.calendar,
                  title: 'Appointments',
                  count: '3',
                  color: AppColors.warning,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: _CategoryCard(
                  icon: Iconsax.danger,
                  title: 'Allergies',
                  count: '2',
                  color: AppColors.error,
                  onTap: () {},
                ),
              ),
            ],
          )
              .animate(delay: 100.ms)
              .slideX(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          const SizedBox(height: AppTheme.spaceLg),

          // Upcoming reminders
          const Text(
            'Upcoming Reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          )
              .animate(delay: 150.ms)
              .slideX(
                begin: -0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          const SizedBox(height: AppTheme.spaceSm),

          _ReminderCard(
            title: 'Blood Pressure Medication',
            time: '8:00 AM',
            type: 'medication',
            index: 0,
          ),
          _ReminderCard(
            title: 'Dr. Johnson Checkup',
            time: 'Tomorrow, 2:30 PM',
            type: 'appointment',
            index: 1,
          ),
          _ReminderCard(
            title: 'Vitamin D Supplement',
            time: '12:00 PM',
            type: 'medication',
            index: 2,
          ),

          const SizedBox(height: AppTheme.spaceXxl),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String title;
  final String time;
  final String type;
  final int index;

  const _ReminderCard({
    required this.title,
    required this.time,
    required this.type,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isMedication = type == 'medication';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceXs),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isMedication ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(
              isMedication ? Iconsax.health : Iconsax.calendar,
              color: isMedication ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Iconsax.tick_circle, color: AppColors.success),
            onPressed: () {
              // TODO: Mark as done
            },
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 200 + (index * 50)))
        .slideX(
          begin: 0.2,
          end: 0,
          duration: AppAnimations.medium,
          curve: AppAnimations.slideIn,
        );
  }
}
