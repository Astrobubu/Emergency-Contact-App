import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/buttons/emergency_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Floating App Bar with Notification Icon
            SliverAppBar(
              floating: true,
              pinned: false, // Allow it to scroll away/fade
              snap: true,
              backgroundColor: Colors.transparent, // Transparent to blend/fade
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Iconsax.user, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Ahmad',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Family Connected',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: AppTheme.spaceMd),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.notification, color: AppColors.textPrimary),
                    onPressed: () {
                      // TODO: Open Notifications Page
                    },
                  ),
                ),
              ],
            ),

            // Emergency Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceSm,
                  AppTheme.spaceMd,
                  AppTheme.spaceSm,
                ),
                child: EmergencyButton(
                  onPressed: () => context.push(RouteNames.emergencyTrigger),
                ),
              ),
            ),

            // Family Members (Top Priority)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: AppTheme.spaceSm),
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
                    Icon(Iconsax.push_pin, size: 18, color: AppColors.textMuted), // Pinned indicator
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 110, // Increased height for better interaction
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final members = ['Mom', 'Dad', 'Sarah', 'Mike', 'Add'];
                    final memberIds = ['1', '2', '3', '4', ''];
                    final isAdd = index == 4;
                    // Mock pinning first 2 members
                    final isPinned = index < 2;

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
                            Stack(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
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
                                    boxShadow: isPinned ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ) 
                                    ] : null,
                                  ),
                                  child: Icon(
                                    isAdd ? Iconsax.add : Iconsax.user,
                                    color: isAdd
                                        ? AppColors.textMuted
                                        : AppColors.primary,
                                    size: isAdd ? 28 : 28,
                                  ),
                                ),
                                if (isPinned && !isAdd)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.surface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Iconsax.push_pin, size: 10, color: AppColors.primary),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              members[index],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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

            // Notifications / Coming Up (Middle)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceMd,
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
            SliverToBoxAdapter(
              child: SizedBox(
                height: 80, // Slightly more compact
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
                  ],
                ),
              ),
            ),

            // Quick Actions (Moved to Bottom)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceXl, // Extra space before Quick Actions
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppTheme.spaceSm,
                  crossAxisSpacing: AppTheme.spaceSm,
                  childAspectRatio: 1.4, // Slightly wider
                ),
                delegate: SliverChildListDelegate([
                  QuickActionCard(
                    icon: Iconsax.health,
                    title: 'Medical Hub',
                    subtitle: 'Records',
                    iconColor: AppColors.error,
                    onTap: () => context.push(RouteNames.medicalHub),
                  ),
                  QuickActionCard(
                    icon: Iconsax.document,
                    title: 'Documents',
                    subtitle: 'Vault',
                    iconColor: AppColors.info,
                    onTap: () => context.push(RouteNames.documentsVault),
                  ),
                ]),
              ),
            ),

            // Bottom Spacer
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
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
