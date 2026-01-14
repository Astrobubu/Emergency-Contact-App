import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class FamilyMapScreen extends ConsumerWidget {
  const FamilyMapScreen({super.key});

  // Mock family member positions
  static const _familyMembers = [
    {'name': 'Mom', 'location': 'Home', 'lastSeen': 'Now', 'x': 0.3, 'y': 0.35, 'id': '1'},
    {'name': 'Dad', 'location': 'Office', 'lastSeen': '5 min ago', 'x': 0.65, 'y': 0.25, 'id': '2'},
    {'name': 'Sarah', 'location': 'School', 'lastSeen': '10 min ago', 'x': 0.5, 'y': 0.55, 'id': '3'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Mock Map Background - solid color, NO gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE8DDD4), // Solid beige for map
            child: CustomPaint(
              painter: _MockMapPainter(),
            ),
          ),

          // Family member markers
          ..._familyMembers.map((member) => _FamilyMarker(
            name: member['name'] as String,
            location: member['location'] as String,
            lastSeen: member['lastSeen'] as String,
            xPercent: member['x'] as double,
            yPercent: member['y'] as double,
            onTap: () => context.push('/family/member/${member['id']}'),
          )),

          // Top search bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Iconsax.search_normal, color: AppColors.textMuted, size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Search location...',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  Container(
                    width: 48,
                    height: 48,
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
                      icon: const Icon(Iconsax.setting_4, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom panel with family list
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowMedium,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: AppTheme.spaceSm),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Family Locations',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '3 Online',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spaceMd),
                          // Member location cards
                          ..._familyMembers.map((member) => _LocationCard(
                            name: member['name'] as String,
                            location: member['location'] as String,
                            lastSeen: member['lastSeen'] as String,
                            onTap: () => context.push('/family/member/${member['id']}'),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // My location button
          Positioned(
            right: AppTheme.spaceMd,
            bottom: 280,
            child: Container(
              width: 48,
              height: 48,
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
                icon: const Icon(Iconsax.gps, color: AppColors.primary, size: 22),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw mock map roads
class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Draw some "roads"
    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height * 0.7),
      roadPaint,
    );
    // Diagonal road
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.5),
      roadPaint,
    );

    // Draw some "buildings" as rectangles
    final buildingPaint = Paint()
      ..color = const Color(0xFFCDBFB0)
      ..style = PaintingStyle.fill;

    final buildings = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.1, 40, 30),
      Rect.fromLTWH(size.width * 0.75, size.height * 0.15, 50, 40),
      Rect.fromLTWH(size.width * 0.15, size.height * 0.5, 35, 35),
      Rect.fromLTWH(size.width * 0.6, size.height * 0.45, 45, 35),
    ];

    for (final building in buildings) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(building, const Radius.circular(4)),
        buildingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FamilyMarker extends StatelessWidget {
  final String name;
  final String location;
  final String lastSeen;
  final double xPercent;
  final double yPercent;
  final VoidCallback onTap;

  const _FamilyMarker({
    required this.name,
    required this.location,
    required this.lastSeen,
    required this.xPercent,
    required this.yPercent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * xPercent - 25,
      top: MediaQuery.of(context).size.height * yPercent - 50,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            // Info bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    lastSeen,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Marker pin
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String name;
  final String location;
  final String lastSeen;
  final VoidCallback onTap;

  const _LocationCard({
    required this.name,
    required this.location,
    required this.lastSeen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      name[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastSeen,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
