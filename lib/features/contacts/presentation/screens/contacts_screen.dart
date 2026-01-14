import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();

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
        title: const Text('Contacts'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to add contact
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
              hintText: 'Search contacts...',
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

          // Category chips
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              children: [
                _CategoryChip(
                  label: 'All',
                  isSelected: true,
                  onTap: () {},
                ),
                _CategoryChip(
                  label: 'Emergency',
                  icon: Iconsax.danger,
                  iconColor: AppColors.emergency,
                  onTap: () {},
                ),
                _CategoryChip(
                  label: 'Medical',
                  icon: Iconsax.health,
                  iconColor: AppColors.error,
                  onTap: () {},
                ),
                _CategoryChip(
                  label: 'Personal',
                  icon: Iconsax.user,
                  iconColor: AppColors.info,
                  onTap: () {},
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

          const SizedBox(height: AppTheme.spaceSm),

          // Contacts list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _ContactListItem(
                  name: _contactNames[index % _contactNames.length],
                  relationship: _relationships[index % _relationships.length],
                  isEmergency: index < 2,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const _contactNames = [
    'Dr. Sarah Johnson',
    'Mom',
    'Dad',
    'Uncle Mike',
    'Aunt Lisa',
    'Neighbor Tom',
    'Dr. Patel',
    'Insurance Agent',
    'School Office',
    'Babysitter Jane',
  ];

  static const _relationships = [
    'Family Doctor',
    'Mother',
    'Father',
    'Uncle',
    'Aunt',
    'Neighbor',
    'Specialist',
    'Insurance',
    'School',
    'Caretaker',
  ];
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.icon,
    this.iconColor,
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
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : iconColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
      ),
    );
  }
}

class _ContactListItem extends StatelessWidget {
  final String name;
  final String relationship;
  final bool isEmergency;
  final int index;

  const _ContactListItem({
    required this.name,
    required this.relationship,
    this.isEmergency = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceXs),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceXs,
        ),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Text(
                name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isEmergency)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.emergency,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.star,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          relationship,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Iconsax.call, color: AppColors.success),
              onPressed: () {
                // TODO: Make call
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.message, color: AppColors.primary),
              onPressed: () {
                // TODO: Send message
              },
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + (index * 50)))
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
