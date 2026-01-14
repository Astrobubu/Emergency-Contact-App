import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/buttons/emergency_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Ahmad',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              .animate()
                              .slideX(
                                begin: -0.2,
                                end: 0,
                                duration: AppAnimations.medium,
                                curve: AppAnimations.slideIn,
                              ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your family is safe',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                              .animate(delay: 50.ms)
                              .slideX(
                                begin: -0.2,
                                end: 0,
                                duration: AppAnimations.medium,
                                curve: AppAnimations.slideIn,
                              ),
                        ],
                      ),
                    ),
                    // Profile avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Iconsax.user,
                        color: AppColors.primary,
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          duration: AppAnimations.medium,
                          curve: AppAnimations.bounce,
                        ),
                  ],
                ),
              ),
            ),

            // Emergency Button - Simple and clear
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                  vertical: AppTheme.spaceSm,
                ),
                child: EmergencyButton(
                  onPressed: () => context.push(RouteNames.emergencyTrigger),
                ),
              ),
            ),

            // Upcoming Notifications Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceLg,
                  AppTheme.spaceMd,
                  AppTheme.spaceSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Coming Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            // Notification Cards
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
                  children: const [
                    _NotificationCard(
                      icon: Iconsax.calendar,
                      title: 'Dr. Johnson Checkup',
                      subtitle: 'Dad • Tomorrow 2:30 PM',
                      color: AppColors.warning,
                    ),
                    _NotificationCard(
                      icon: Iconsax.shield_tick,
                      title: 'Insurance Expiring',
                      subtitle: 'Mom • Dec 25, 2025',
                      color: AppColors.error,
                    ),
                    _NotificationCard(
                      icon: Iconsax.health,
                      title: 'Medication Reminder',
                      subtitle: 'Dad • 8:00 PM today',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ),

            // Quick Actions Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceLg,
                  AppTheme.spaceMd,
                  AppTheme.spaceSm,
                ),
                child: const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Quick Actions Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppTheme.spaceSm,
                  crossAxisSpacing: AppTheme.spaceSm,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildListDelegate([
                  QuickActionCard(
                    icon: Iconsax.health,
                    title: 'Medical Hub',
                    subtitle: 'Records & medications',
                    iconColor: AppColors.error,
                    onTap: () => context.push(RouteNames.medicalHub),
                  ),
                  QuickActionCard(
                    icon: Iconsax.document,
                    title: 'All Documents',
                    subtitle: 'View all family docs',
                    iconColor: AppColors.info,
                    onTap: () => context.push(RouteNames.documentsVault),
                  ),
                ]),
              ),
            ),

            // Family Status Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceLg,
                  AppTheme.spaceMd,
                  AppTheme.spaceSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Family Members',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(RouteNames.family),
                      child: const Text('See all'),
                    ),
                  ],
                )
                    .animate(delay: 400.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),
              ),
            ),

            // Family Members List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final members = ['Mom', 'Dad', 'Sarah', 'Mike', 'Add'];
                    final memberIds = ['1', '2', '3', '4', ''];
                    final isAdd = index == 4;

                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spaceSm),
                      child: GestureDetector(
                        onTap: () {
                          if (isAdd) {
                            context.push('/family/add');
                          } else {
                            context.push('/family/member/${memberIds[index]}');
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isAdd
                                    ? AppColors.surfaceVariant
                                    : AppColors.primaryContainer,
                                shape: BoxShape.circle,
                                border: isAdd
                                    ? Border.all(
                                        color: AppColors.border,
                                        width: 2,
                                        strokeAlign: BorderSide.strokeAlignOutside,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                isAdd ? Iconsax.add : Iconsax.user,
                                color: isAdd
                                    ? AppColors.textMuted
                                    : AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              members[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isAdd
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spaceXxl),
            ),
          ],
        ),
      ),
    );
  }
}

// Notification card for upcoming events
class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: AppTheme.spaceSm),
      padding: const EdgeInsets.all(AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
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
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppTheme.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
