import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual password reset logic with Supabase
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Iconsax.lock_1,
                    color: AppColors.primary,
                    size: 32,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: AppAnimations.medium,
                      curve: AppAnimations.bounce,
                    ),

                const SizedBox(height: AppTheme.spaceLg),

                // Title
                Text(
                  _emailSent ? 'Check your email' : 'Forgot password?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
                    .animate(delay: 50.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXs),

                Text(
                  _emailSent
                      ? 'We sent a password reset link to\n${_emailController.text}'
                      : "No worries, we'll send you reset instructions.",
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                )
                    .animate(delay: 100.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXl),

                if (!_emailSent) ...[
                  // Email field
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Iconsax.sms,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleResetPassword(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  )
                      .animate(delay: 150.ms)
                      .slideX(
                        begin: 0.2,
                        end: 0,
                        duration: AppAnimations.medium,
                        curve: AppAnimations.slideIn,
                      ),

                  const SizedBox(height: AppTheme.spaceLg),

                  // Reset button
                  PrimaryButton(
                    text: 'Reset Password',
                    onPressed: _handleResetPassword,
                    isLoading: _isLoading,
                  )
                      .animate(delay: 200.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: AppAnimations.medium,
                        curve: AppAnimations.slideIn,
                      ),
                ] else ...[
                  // Success icon
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.tick_circle5,
                        color: AppColors.success,
                        size: 50,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: AppAnimations.medium,
                        curve: AppAnimations.bounce,
                      ),

                  const SizedBox(height: AppTheme.spaceLg),

                  // Back to login button
                  PrimaryButton(
                    text: 'Back to Login',
                    onPressed: () => context.pop(),
                  )
                      .animate(delay: 150.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: AppAnimations.medium,
                        curve: AppAnimations.slideIn,
                      ),

                  const SizedBox(height: AppTheme.spaceMd),

                  // Resend link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() => _emailSent = false);
                      },
                      child: const Text("Didn't receive the email? Click to resend"),
                    ),
                  )
                      .animate(delay: 200.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: AppAnimations.medium,
                        curve: AppAnimations.slideIn,
                      ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
