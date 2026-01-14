import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class InsuranceVaultScreen extends ConsumerStatefulWidget {
  const InsuranceVaultScreen({super.key});

  @override
  ConsumerState<InsuranceVaultScreen> createState() =>
      _InsuranceVaultScreenState();
}

class _InsuranceVaultScreenState extends ConsumerState<InsuranceVaultScreen> {
  final _searchController = TextEditingController();
  String _selectedType = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Insurance'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {
              // TODO: Add new insurance document
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: SearchTextField(
              controller: _searchController,
              hintText: 'Search insurance policies...',
              onChanged: (value) {
                // TODO: Implement search
              },
            ),
          )
              .animate()
              .slideY(
                begin: -0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          // Type chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              children: [
                _TypeChip(
                  label: 'All',
                  isSelected: _selectedType == 'all',
                  onTap: () => setState(() => _selectedType = 'all'),
                ),
                _TypeChip(
                  label: 'Health',
                  icon: Iconsax.health,
                  isSelected: _selectedType == 'health',
                  onTap: () => setState(() => _selectedType = 'health'),
                ),
                _TypeChip(
                  label: 'Life',
                  icon: Iconsax.heart,
                  isSelected: _selectedType == 'life',
                  onTap: () => setState(() => _selectedType = 'life'),
                ),
                _TypeChip(
                  label: 'Auto',
                  icon: Iconsax.car,
                  isSelected: _selectedType == 'auto',
                  onTap: () => setState(() => _selectedType = 'auto'),
                ),
                _TypeChip(
                  label: 'Home',
                  icon: Iconsax.home,
                  isSelected: _selectedType == 'home',
                  onTap: () => setState(() => _selectedType = 'home'),
                ),
              ],
            ),
          )
              .animate(delay: 50.ms)
              .slideX(
                begin: -0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          const SizedBox(height: AppTheme.spaceMd),

          // Insurance list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              itemCount: _insurancePolicies.length,
              itemBuilder: (context, index) {
                final policy = _insurancePolicies[index];
                return _InsuranceCard(
                  providerName: policy['provider']!,
                  policyType: policy['type']!,
                  policyNumber: policy['policyNumber']!,
                  expiryDate: policy['expiry']!,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Upload insurance document
        },
        icon: const Icon(Iconsax.document_upload),
        label: const Text('Add Policy'),
        backgroundColor: AppColors.primary,
      )
          .animate(delay: 300.ms)
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: AppAnimations.medium,
            curve: AppAnimations.bounce,
          ),
    );
  }

  static const _insurancePolicies = [
    {
      'provider': 'Blue Cross Blue Shield',
      'type': 'health',
      'policyNumber': 'BCBS-12345678',
      'expiry': 'Dec 31, 2025',
    },
    {
      'provider': 'Prudential Life',
      'type': 'life',
      'policyNumber': 'PRU-87654321',
      'expiry': 'Mar 15, 2026',
    },
    {
      'provider': 'State Farm',
      'type': 'auto',
      'policyNumber': 'SF-AUTO-999888',
      'expiry': 'Jun 30, 2025',
    },
    {
      'provider': 'Allstate Home',
      'type': 'home',
      'policyNumber': 'ALL-HOME-777666',
      'expiry': 'Sep 1, 2025',
    },
  ];
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spaceXs),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.success,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InsuranceCard extends StatelessWidget {
  final String providerName;
  final String policyType;
  final String policyNumber;
  final String expiryDate;
  final int index;

  const _InsuranceCard({
    required this.providerName,
    required this.policyType,
    required this.policyNumber,
    required this.expiryDate,
    required this.index,
  });

  IconData get _typeIcon {
    switch (policyType) {
      case 'health':
        return Iconsax.health;
      case 'life':
        return Iconsax.heart;
      case 'auto':
        return Iconsax.car;
      case 'home':
        return Iconsax.home;
      default:
        return Iconsax.shield_tick;
    }
  }

  Color get _typeColor {
    switch (policyType) {
      case 'health':
        return AppColors.error;
      case 'life':
        return AppColors.secondary;
      case 'auto':
        return AppColors.info;
      case 'home':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with icon
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceSm),
                  decoration: BoxDecoration(
                    color: _typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(_typeIcon, color: _typeColor, size: 24),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        policyType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Iconsax.more, color: AppColors.textMuted),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('View Details')),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'share', child: Text('Share')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Policy Number',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        policyNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expires',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        expiryDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + (index * 80)))
        .slideY(
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
        );
  }
}
