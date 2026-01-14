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
import 'package:family_emergency_hub/features/family/data/family_repository.dart';
import 'package:family_emergency_hub/features/notifications/data/notification_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(familyMembersProvider);
    final notificationsAsync = ref.watch(upcomingNotificationsProvider);

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
            // Floating App Bar
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  // User Avatar - Subtle (Icon only or minimal bg)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1), // Subtle tint
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.user, color: AppColors.primary, size: 20),
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
                // Notification Icon - Subtle
                Container(
                  margin: const EdgeInsets.only(right: AppTheme.spaceMd),
                  child: IconButton(
                    icon: const Icon(Iconsax.notification, color: AppColors.textPrimary),
                    onPressed: () {
                      // TODO: Open Notifications Page
                    },
                  ),
                ),
              ],
            ),

            // Emergency Button (Bigger & Clearer)
            // Emergency Button (Bigger & Clearer)
            SliverToBoxAdapter(
              child: Center(
                child: AppCard(
                  onTap: () => context.push(RouteNames.emergencyTrigger),
                  margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: AppTheme.spaceMd),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColors.error,
                  shadowColor: AppColors.error.withValues(alpha: 0.3),
                  elevation: 12,
                  borderRadius: AppTheme.radiusLg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Iconsax.warning_2, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'EMERGENCY SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Family Members (Dynamic - Split Layout)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.spaceMd, AppTheme.spaceSm, AppTheme.spaceMd, AppTheme.spaceSm),
                child: const Text(
                  'My Family',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: familyAsync.when(
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(),
                data: (members) {
                  final pinnedMembers = members.take(2).toList(); // First 2 are pinned
                  final otherMembers = members.skip(2).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Pinned (Large)
                      if (pinnedMembers.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: pinnedMembers.map((member) {
                              return Column(
                                children: [
                                  AppCard(
                                    onTap: () => context.push('/family/member/${member.id}'),
                                    padding: const EdgeInsets.all(20), // Padding creates size (36 icon + 20*2 = 76 approx)
                                    margin: EdgeInsets.zero,
                                    borderRadius: 999, // Circle
                                    backgroundColor: AppColors.primaryContainer,
                                    shadowColor: AppColors.shadow.withValues(alpha: 0.5),
                                    elevation: 6,
                                    child: const Icon(Iconsax.user, color: AppColors.primary, size: 36),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Safe',
                                      style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Row 2: Others + Add Button (Horizontal List)
                      SizedBox(
                        height: 100, // Slightly taller to accommodate shadows
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: 4),
                          itemCount: otherMembers.length + 1,
                          itemBuilder: (context, index) {
                            if (index == otherMembers.length) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 20), // Align with text
                                  child: _buildAddMemberButton(context),
                                ),
                              );
                            }
                            final member = otherMembers[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  AppCard(
                                    onTap: () => context.push('/family/member/${member.id}'),
                                    padding: const EdgeInsets.all(14), // Smaller padding for smaller size
                                    margin: EdgeInsets.zero,
                                    borderRadius: 999,
                                    backgroundColor: AppColors.surface,
                                    elevation: 2,
                                    child: const Icon(Iconsax.user, color: AppColors.textSecondary, size: 24),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Notifications / Coming Up
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppTheme.spaceMd, AppTheme.spaceMd, AppTheme.spaceMd, AppTheme.spaceSm),
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
                      // Wired up to navigate even if empty
                      onPressed: () => context.push(RouteNames.medicalHub), 
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100, // Increased from 90 to 100
                child: notificationsAsync.when(
                  loading: () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
                    itemCount: 3,
                    itemBuilder: (context, index) => _buildShimmerNotification(),
                  ),
                  error: (_, __) => const SizedBox(),
                  data: (notifications) => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: 4), // Added vertical padding
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return _NotificationCard(
                        icon: notif.icon,
                        title: notif.title,
                        subtitle: notif.subtitle,
                        color: notif.color,
                      );
                    },
                  ),
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spaceMd,
                  AppTheme.spaceXl,
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
                  childAspectRatio: 1.4,
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

  Widget _buildAddMemberButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spaceSm),
      child: GestureDetector(
        onTap: () => context.push('/family/add'),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              child: const Icon(Iconsax.add, color: AppColors.textMuted, size: 28),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spaceSm),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 10,
            color: const Color(0xFFEEEEEE),
          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildShimmerNotification() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: AppTheme.spaceSm),
      padding: const EdgeInsets.all(AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
          ),
          const SizedBox(width: AppTheme.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 80, height: 10, color: const Color(0xFFEEEEEE)),
                const SizedBox(height: 4),
                Container(width: 120, height: 10, color: const Color(0xFFEEEEEE)),
              ],
            ),
          ),
        ],
      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: Colors.white),
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
