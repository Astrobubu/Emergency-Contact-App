import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class FamilyMemberDetailScreen extends ConsumerStatefulWidget {
  final String memberId;

  const FamilyMemberDetailScreen({
    super.key,
    required this.memberId,
  });

  @override
  ConsumerState<FamilyMemberDetailScreen> createState() =>
      _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState
    extends ConsumerState<FamilyMemberDetailScreen> {
  // Mock data - would come from Supabase
  final _memberData = {
    'name': 'Dad',
    'fullName': 'Ahmad Hassan',
    'relationship': 'Father',
    'phone': '+971 50 123 4567',
    'email': 'ahmad@email.com',
    'bloodType': 'O+',
    'age': '52',
    'status': 'Healthy',
  };

  final _syncedData = [
    {'name': 'Blood Sugar', 'value': '98 mg/dL', 'status': 'normal', 'app': 'Health Connect'},
    {'name': 'Blood Pressure', 'value': '120/80', 'status': 'normal', 'app': 'Samsung Health'},
    {'name': 'Heart Rate', 'value': '72 bpm', 'status': 'normal', 'app': 'Fitbit'},
  ];

  final _activityLog = [
    {'date': 'Jan 12, 2026', 'title': 'Dentist Visit', 'desc': 'Routine cleaning', 'icon': Iconsax.health},
    {'date': 'Jan 5, 2026', 'title': 'Eye Checkup', 'desc': 'Annual vision test - 20/20', 'icon': Iconsax.eye},
    {'date': 'Dec 20, 2025', 'title': 'Blood Test', 'desc': 'Annual blood work - all normal', 'icon': Iconsax.drop},
    {'date': 'Nov 15, 2025', 'title': 'Flu Vaccination', 'desc': 'Seasonal flu shot', 'icon': Iconsax.health},
  ];

  final _documents = [
    {'name': 'Health Insurance', 'type': 'insurance', 'expiry': 'Dec 2025'},
    {'name': 'Passport', 'type': 'id', 'expiry': 'Mar 2028'},
    {'name': 'Emirates ID', 'type': 'id', 'expiry': 'Jun 2027'},
    {'name': 'Driver License', 'type': 'id', 'expiry': 'Sep 2026'},
  ];

  final _medications = [
    {'name': 'Metformin', 'dosage': '500mg', 'frequency': 'Twice daily'},
    {'name': 'Vitamin D', 'dosage': '1000 IU', 'frequency': 'Once daily'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Simple App Bar - NO GRADIENTS
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.edit, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Iconsax.call, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary, // SOLID color, NO gradient
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar - NO borders
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Iconsax.user, size: 40, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _memberData['fullName']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _memberData['relationship']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Quick Stats Row - NO BORDERS, use shadows/contrast
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: Row(
                children: [
                  _QuickStatChip(
                    icon: Iconsax.drop,
                    label: 'Blood',
                    value: _memberData['bloodType']!,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  _QuickStatChip(
                    icon: Iconsax.cake,
                    label: 'Age',
                    value: _memberData['age']!,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  _QuickStatChip(
                    icon: Iconsax.heart,
                    label: 'Status',
                    value: _memberData['status']!,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
          ),

          // Synced Health Data Section
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Synced Health Data', icon: Iconsax.activity),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
                itemCount: _syncedData.length,
                itemBuilder: (context, index) {
                  final data = _syncedData[index];
                  return _SyncedDataCard(
                    name: data['name']!,
                    value: data['value']!,
                    app: data['app']!,
                    isNormal: data['status'] == 'normal',
                  );
                },
              ),
            ),
          ),

          // Activity Log Section
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Activity Log',
              icon: Iconsax.calendar,
              action: TextButton(
                onPressed: () {},
                child: const Text('See all'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final activity = _activityLog[index];
                return _ActivityLogItem(
                  date: activity['date'] as String,
                  title: activity['title'] as String,
                  description: activity['desc'] as String,
                  icon: activity['icon'] as IconData,
                );
              },
              childCount: _activityLog.length,
            ),
          ),

          // Documents Section
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Documents', icon: Iconsax.document),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              child: Wrap(
                spacing: AppTheme.spaceSm,
                runSpacing: AppTheme.spaceSm,
                children: _documents.map((doc) => _DocumentChip(
                  name: doc['name']!,
                  type: doc['type']!,
                  expiry: doc['expiry']!,
                )).toList(),
              ),
            ),
          ),

          // Medications Section
          SliverToBoxAdapter(
            child: _SectionHeader(title: 'Current Medications', icon: Iconsax.hospital),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final med = _medications[index];
                return _MedicationItem(
                  name: med['name']!,
                  dosage: med['dosage']!,
                  frequency: med['frequency']!,
                );
              },
              childCount: _medications.length,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Iconsax.add),
        label: const Text('Add Entry'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

// NO BORDERS - just shadows and contrast
class _QuickStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface, // Contrast with background
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? action;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceMd,
        AppTheme.spaceLg,
        AppTheme.spaceMd,
        AppTheme.spaceSm,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}

// NO BORDERS - shadow and contrast only
class _SyncedDataCard extends StatelessWidget {
  final String name;
  final String value;
  final String app;
  final bool isNormal;

  const _SyncedDataCard({
    required this.name,
    required this.value,
    required this.app,
    required this.isNormal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: AppTheme.spaceSm),
      padding: const EdgeInsets.all(AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface, // Contrast
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isNormal ? AppColors.success : AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'via $app',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// NO BORDERS - shadow and contrast
class _ActivityLogItem extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final IconData icon;

  const _ActivityLogItem({
    required this.date,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: 4,
      ),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppTheme.spaceSm),
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
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// NO BORDERS - shadow and contrast
class _DocumentChip extends StatelessWidget {
  final String name;
  final String type;
  final String expiry;

  const _DocumentChip({
    required this.name,
    required this.type,
    required this.expiry,
  });

  IconData get _icon {
    switch (type) {
      case 'insurance':
        return Iconsax.shield_tick;
      case 'id':
        return Iconsax.personalcard;
      default:
        return Iconsax.document;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface, // Contrast
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Exp: $expiry',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// NO BORDERS - shadow and contrast
class _MedicationItem extends StatelessWidget {
  final String name;
  final String dosage;
  final String frequency;

  const _MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: 4,
      ),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Iconsax.hospital, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: AppTheme.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$dosage • $frequency',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
