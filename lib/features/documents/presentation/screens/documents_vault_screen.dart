import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class DocumentsVaultScreen extends ConsumerStatefulWidget {
  const DocumentsVaultScreen({super.key});

  @override
  ConsumerState<DocumentsVaultScreen> createState() =>
      _DocumentsVaultScreenState();
}

class _DocumentsVaultScreenState extends ConsumerState<DocumentsVaultScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = true;

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
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Iconsax.menu : Iconsax.grid_5),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.add_circle),
            onPressed: () {
              // TODO: Add new document
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
              hintText: 'Search documents...',
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
                _CategoryChip(label: 'All', isSelected: true, onTap: () {}),
                _CategoryChip(
                    label: 'ID', icon: Iconsax.personalcard, onTap: () {}),
                _CategoryChip(
                    label: 'Legal', icon: Iconsax.document, onTap: () {}),
                _CategoryChip(
                    label: 'Financial', icon: Iconsax.dollar_circle, onTap: () {}),
                _CategoryChip(
                    label: 'Property', icon: Iconsax.home, onTap: () {}),
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

          // Documents grid/list
          Expanded(
            child: _isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Upload document
        },
        icon: const Icon(Iconsax.document_upload),
        label: const Text('Upload'),
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

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppTheme.spaceSm,
        crossAxisSpacing: AppTheme.spaceSm,
        childAspectRatio: 0.85,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _DocumentGridItem(
          title: _documentNames[index % _documentNames.length],
          type: _documentTypes[index % _documentTypes.length],
          date: 'Dec ${10 + index}, 2024',
          index: index,
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _DocumentListItem(
          title: _documentNames[index % _documentNames.length],
          type: _documentTypes[index % _documentTypes.length],
          date: 'Dec ${10 + index}, 2024',
          size: '${(index + 1) * 125} KB',
          index: index,
        );
      },
    );
  }

  static const _documentNames = [
    'Passport',
    'Driver License',
    'Birth Certificate',
    'Insurance Policy',
    'Property Deed',
    'Tax Returns 2024',
    'Marriage Certificate',
    'Vehicle Registration',
  ];

  static const _documentTypes = [
    'pdf',
    'jpg',
    'pdf',
    'pdf',
    'pdf',
    'pdf',
    'pdf',
    'jpg',
  ];
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
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
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DocumentGridItem extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final int index;

  const _DocumentGridItem({
    required this.title,
    required this.type,
    required this.date,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = type == 'pdf';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File preview
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isPdf
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.info.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusMd),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPdf ? Iconsax.document_text : Iconsax.image,
                    size: 40,
                    color: isPdf ? AppColors.error : AppColors.info,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPdf ? AppColors.error : AppColors.info,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // File info
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 100 + (index * 50)))
        .slideY(
          begin: 0.2,
          end: 0,
          duration: AppAnimations.medium,
          curve: AppAnimations.slideIn,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: AppAnimations.medium,
          curve: AppAnimations.scaleUp,
        );
  }
}

class _DocumentListItem extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final String size;
  final int index;

  const _DocumentListItem({
    required this.title,
    required this.type,
    required this.date,
    required this.size,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = type == 'pdf';

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
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isPdf
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: Icon(
            isPdf ? Iconsax.document_text : Iconsax.image,
            color: isPdf ? AppColors.error : AppColors.info,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '$date  |  $size',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Iconsax.more, color: AppColors.textMuted),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View')),
            const PopupMenuItem(value: 'share', child: Text('Share')),
            const PopupMenuItem(value: 'download', child: Text('Download')),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: AppColors.error)),
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
        );
  }
}
