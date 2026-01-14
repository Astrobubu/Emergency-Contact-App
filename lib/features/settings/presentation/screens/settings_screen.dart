import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/cards/app_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        children: [
          // Profile Section
          AppCard(
            onTap: () {
              // TODO: Navigate to profile
            },
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Iconsax.user,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ahmad',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ahmad@example.com',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
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
              ),

          const SizedBox(height: AppTheme.spaceLg),

          // Settings sections
          _buildSectionTitle('General'),
          const SizedBox(height: AppTheme.spaceXs),

          _SettingsTile(
            icon: Iconsax.notification,
            title: 'Notifications',
            subtitle: 'Push, sounds, alerts',
            onTap: () {},
            index: 0,
          ),
          _SettingsTile(
            icon: Iconsax.location,
            title: 'Location Sharing',
            subtitle: 'Always on',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.successDark,
                ),
              ),
            ),
            onTap: () {},
            index: 1,
          ),
          _SettingsTile(
            icon: Iconsax.shield_tick,
            title: 'Privacy',
            subtitle: 'Data, permissions',
            onTap: () {},
            index: 2,
          ),

          const SizedBox(height: AppTheme.spaceLg),
          _buildSectionTitle('Emergency'),
          const SizedBox(height: AppTheme.spaceXs),

          _SettingsTile(
            icon: Iconsax.heart,
            title: 'Emergency ID',
            subtitle: 'Medical info for lock screen',
            onTap: () {},
            index: 3,
          ),
          _SettingsTile(
            icon: Iconsax.call,
            title: 'Emergency Contacts',
            subtitle: '3 contacts set',
            onTap: () {},
            index: 4,
          ),

          const SizedBox(height: AppTheme.spaceLg),
          _buildSectionTitle('Support'),
          const SizedBox(height: AppTheme.spaceXs),

          _SettingsTile(
            icon: Iconsax.message_question,
            title: 'Help Center',
            subtitle: 'FAQs, guides',
            onTap: () {},
            index: 5,
          ),
          _SettingsTile(
            icon: Iconsax.info_circle,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
            index: 6,
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // Logout button
          AppCard(
            onTap: () {
              // TODO: Implement logout
            },
            backgroundColor: AppColors.errorLight.withValues(alpha: 0.3),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.logout, color: AppColors.error),
                SizedBox(width: AppTheme.spaceXs),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 400.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          const SizedBox(height: AppTheme.spaceXxl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXs),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final int index;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero, // Let ListTile handle internal padding if needed, or just layout
      margin: const EdgeInsets.only(bottom: AppTheme.spaceXs),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: false,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        trailing: trailing ??
            const Icon(
              Iconsax.arrow_right_3,
              color: AppColors.textMuted,
              size: 18,
            ),
      ),
    )
    .animate(delay: Duration(milliseconds: 100 + (index * 50)))
    .slideX(
      begin: 0.2,
      end: 0,
      duration: AppAnimations.medium,
      curve: AppAnimations.slideIn,
    );
  }
}
