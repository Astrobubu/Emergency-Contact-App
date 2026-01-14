import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/buttons/emergency_button.dart';

class EmergencyTriggerScreen extends ConsumerStatefulWidget {
  const EmergencyTriggerScreen({super.key});

  @override
  ConsumerState<EmergencyTriggerScreen> createState() =>
      _EmergencyTriggerScreenState();
}

class _EmergencyTriggerScreenState
    extends ConsumerState<EmergencyTriggerScreen> {
  bool _isTriggered = false;
  int _countdown = 5;

  void _triggerEmergency() async {
    HapticFeedback.heavyImpact();
    setState(() => _isTriggered = true);

    // Countdown
    for (int i = 5; i >= 0; i--) {
      if (!mounted || !_isTriggered) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (mounted && _isTriggered) {
      // TODO: Actually send emergency alert
      _showAlertSentDialog();
    }
  }

  void _cancelEmergency() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isTriggered = false;
      _countdown = 5;
    });
  }

  void _showAlertSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.tick_circle5,
                color: AppColors.success,
                size: 48,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: AppAnimations.medium,
                  curve: AppAnimations.bounce,
                ),
            const SizedBox(height: AppTheme.spaceMd),
            const Text(
              'Alert Sent!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            const Text(
              'Your family has been notified of your emergency.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isTriggered ? AppColors.emergency : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.close_circle,
                      color: _isTriggered ? Colors.white : AppColors.textMuted,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            )
                .animate()
                .slideY(
                  begin: -0.3,
                  end: 0,
                  duration: AppAnimations.medium,
                  curve: AppAnimations.slideIn,
                ),

            const Spacer(),

            // Main content
            if (!_isTriggered) ...[
              // Not triggered state
              Text(
                'Emergency Alert',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: AppAnimations.medium,
                    curve: AppAnimations.slideIn,
                  ),

              const SizedBox(height: AppTheme.spaceXs),

              const Text(
                'Press and hold to alert your family',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              )
                  .animate(delay: 50.ms)
                  .slideY(
                    begin: -0.2,
                    end: 0,
                    duration: AppAnimations.medium,
                    curve: AppAnimations.slideIn,
                  ),

              const SizedBox(height: AppTheme.spaceXxl),

              EmergencyButton(
                size: 160,
                onPressed: _triggerEmergency,
              )
                  .animate(delay: 100.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: AppAnimations.slow,
                    curve: AppAnimations.bounce,
                  ),

              const SizedBox(height: AppTheme.spaceXxl),

              // Quick call buttons
              const Text(
                'Quick Call',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate(delay: 150.ms)
                  .slideY(
                    begin: 0.2,
                    end: 0,
                    duration: AppAnimations.medium,
                    curve: AppAnimations.slideIn,
                  ),

              const SizedBox(height: AppTheme.spaceMd),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QuickCallButton(
                    icon: Iconsax.call,
                    label: '911',
                    color: AppColors.emergency,
                    onTap: () {
                      // TODO: Call 911
                    },
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  _QuickCallButton(
                    icon: Iconsax.hospital,
                    label: 'Poison\nControl',
                    color: AppColors.warning,
                    onTap: () {
                      // TODO: Call poison control
                    },
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  _QuickCallButton(
                    icon: Iconsax.user,
                    label: 'Mom',
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Call mom
                    },
                  ),
                ],
              )
                  .animate(delay: 200.ms)
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: AppAnimations.medium,
                    curve: AppAnimations.slideIn,
                  ),
            ] else ...[
              // Triggered state - countdown
              const Icon(
                Icons.warning_rounded,
                size: 80,
                color: Colors.white,
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: const Duration(milliseconds: 500),
                  ),

              const SizedBox(height: AppTheme.spaceMd),

              const Text(
                'SENDING ALERT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: AppTheme.spaceLg),

              // Countdown
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1, 1),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppTheme.spaceXxl),

              // Cancel button
              OutlinedButton.icon(
                onPressed: _cancelEmergency,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceLg,
                    vertical: AppTheme.spaceMd,
                  ),
                ),
                icon: const Icon(Iconsax.close_circle),
                label: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _QuickCallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCallButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
