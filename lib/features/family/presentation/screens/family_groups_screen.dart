import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class FamilyGroupsScreen extends ConsumerWidget {
  const FamilyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Families'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {
              // TODO: Navigate to create family
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        children: [
          // Primary Family Card
          AppCard(
            onTap: () {
              // TODO: Navigate to family detail
            },
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Iconsax.home_25,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Family',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.successDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '5 members',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          )
              .animate()
              .slideX(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              )
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: AppAnimations.medium,
                curve: AppAnimations.scaleUp,
              ),

          const SizedBox(height: AppTheme.spaceSm),

          // Extended Family Card
          AppCard(
            onTap: () {
              // TODO: Navigate to family detail
            },
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Iconsax.people5,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Extended Family',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: const Text(
                              'Member',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '12 members',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          )
              .animate(delay: 50.ms)
              .slideX(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              )
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: AppAnimations.medium,
                curve: AppAnimations.scaleUp,
              ),

          const SizedBox(height: AppTheme.spaceLg),

          // Join Family Section
          AppCard(
            backgroundColor: AppColors.surfaceVariant,
            hasBorder: true,
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Column(
              children: [
                const Icon(
                  Iconsax.scan,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(height: AppTheme.spaceSm),
                const Text(
                  'Join a Family',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter an invite code to join',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Show join dialog
                    },
                    icon: const Icon(Iconsax.add),
                    label: const Text('Enter Code'),
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 100.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),
        ],
      ),
    );
  }
}
