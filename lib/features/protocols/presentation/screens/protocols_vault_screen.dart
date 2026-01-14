import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';

class ProtocolsVaultScreen extends ConsumerStatefulWidget {
  const ProtocolsVaultScreen({super.key});

  @override
  ConsumerState<ProtocolsVaultScreen> createState() =>
      _ProtocolsVaultScreenState();
}

class _ProtocolsVaultScreenState extends ConsumerState<ProtocolsVaultScreen> {
  String _selectedType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Emergency Protocols'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {
              // TODO: Add new protocol
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Type chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              children: [
                _TypeChip(
                  label: 'All',
                  isSelected: _selectedType == 'all',
                  onTap: () => setState(() => _selectedType = 'all'),
                ),
                _TypeChip(
                  label: 'Fire',
                  icon: Iconsax.flash,
                  color: AppColors.error,
                  isSelected: _selectedType == 'fire',
                  onTap: () => setState(() => _selectedType = 'fire'),
                ),
                _TypeChip(
                  label: 'Medical',
                  icon: Iconsax.health,
                  color: AppColors.secondary,
                  isSelected: _selectedType == 'medical',
                  onTap: () => setState(() => _selectedType = 'medical'),
                ),
                _TypeChip(
                  label: 'Natural Disaster',
                  icon: Iconsax.cloud_lightning,
                  color: AppColors.warning,
                  isSelected: _selectedType == 'natural_disaster',
                  onTap: () => setState(() => _selectedType = 'natural_disaster'),
                ),
                _TypeChip(
                  label: 'Security',
                  icon: Iconsax.shield_tick,
                  color: AppColors.info,
                  isSelected: _selectedType == 'security',
                  onTap: () => setState(() => _selectedType = 'security'),
                ),
              ],
            ),
          )
              .animate()
              .slideX(
                begin: -0.2,
                end: 0,
                duration: AppAnimations.medium,
                curve: AppAnimations.slideIn,
              ),

          // Protocols list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              itemCount: _protocols.length,
              itemBuilder: (context, index) {
                final protocol = _protocols[index];
                return _ProtocolCard(
                  title: protocol['title']!,
                  type: protocol['type']!,
                  description: protocol['description']!,
                  stepsCount: int.parse(protocol['steps']!),
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Create new protocol
        },
        icon: const Icon(Iconsax.add),
        label: const Text('New Protocol'),
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

  static const _protocols = [
    {
      'title': 'Home Fire Evacuation',
      'type': 'fire',
      'description': 'Step-by-step guide for safe evacuation during a fire emergency',
      'steps': '7',
    },
    {
      'title': 'Cardiac Emergency Response',
      'type': 'medical',
      'description': 'CPR and defibrillator instructions for heart emergencies',
      'steps': '5',
    },
    {
      'title': 'Earthquake Safety',
      'type': 'natural_disaster',
      'description': 'Drop, Cover, Hold On - earthquake survival guide',
      'steps': '6',
    },
    {
      'title': 'Home Intrusion Protocol',
      'type': 'security',
      'description': 'Safety procedures if intruders enter the home',
      'steps': '4',
    },
    {
      'title': 'Severe Allergic Reaction',
      'type': 'medical',
      'description': 'EpiPen usage and anaphylaxis response',
      'steps': '5',
    },
  ];
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    this.icon,
    this.color,
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
              Icon(icon, size: 16, color: isSelected ? Colors.white : color),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: color ?? AppColors.warning,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  final String title;
  final String type;
  final String description;
  final int stepsCount;
  final int index;

  const _ProtocolCard({
    required this.title,
    required this.type,
    required this.description,
    required this.stepsCount,
    required this.index,
  });

  IconData get _typeIcon {
    switch (type) {
      case 'fire':
        return Iconsax.flash;
      case 'medical':
        return Iconsax.health;
      case 'natural_disaster':
        return Iconsax.cloud_lightning;
      case 'security':
        return Iconsax.shield_tick;
      default:
        return Iconsax.note_2;
    }
  }

  Color get _typeColor {
    switch (type) {
      case 'fire':
        return AppColors.error;
      case 'medical':
        return AppColors.secondary;
      case 'natural_disaster':
        return AppColors.warning;
      case 'security':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  String get _typeLabel {
    switch (type) {
      case 'fire':
        return 'FIRE';
      case 'medical':
        return 'MEDICAL';
      case 'natural_disaster':
        return 'DISASTER';
      case 'security':
        return 'SECURITY';
      default:
        return 'GENERAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: _typeColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Open protocol details
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              children: [
                // Type icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(_typeIcon, color: _typeColor, size: 28),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _typeColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _typeLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _typeColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$stepsCount steps',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Icon(
                  Iconsax.arrow_right_3,
                  color: _typeColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + (index * 80)))
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
        );
  }
}
