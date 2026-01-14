import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cards/emergency_id_card.dart';

class EmergencyIdScreen extends StatelessWidget {
  final String memberId;

  const EmergencyIdScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency ID'),
        leading: IconButton(
          icon: const Icon(Iconsax.close_circle),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: Column(
          children: [
            const Text(
              'Show this screen to emergency responders',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            // The new widget
            const EmergencyIdCard(
              name: 'Ahmad Hassan',
              bloodType: 'O+',
              allergies: ['Penicillin', 'Peanuts'],
              conditions: ['Type 2 Diabetes', 'Hypertension'],
              emergencyContactName: 'Sarah Hassan',
              emergencyContactPhone: '+971 50 123 4567',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Share ID
                },
                icon: const Icon(Iconsax.share),
                label: const Text('Share Medical ID'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
          ],
        ),
      ),
    );
  }
}
