import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual registration logic with Supabase
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go(RouteNames.home);
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
                // Title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
                    .animate()
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXs),

                const Text(
                  'Join your family emergency hub',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate(delay: 50.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXl),

                // Name field
                AppTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Iconsax.user,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                )
                    .animate(delay: 100.ms)
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceMd),

                // Email field
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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

                const SizedBox(height: AppTheme.spaceMd),

                // Password field
                AppTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: Iconsax.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                )
                    .animate(delay: 200.ms)
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceMd),

                // Confirm password field
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: Iconsax.lock_1,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleRegister(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                )
                    .animate(delay: 250.ms)
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXl),

                // Register button
                PrimaryButton(
                  text: 'Create Account',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                )
                    .animate(delay: 300.ms)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    )
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                      duration: AppAnimations.medium,
                      curve: AppAnimations.scaleUp,
                    ),

                const SizedBox(height: AppTheme.spaceLg),

                // Login link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: 350.ms)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
