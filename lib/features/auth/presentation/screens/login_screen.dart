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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual login logic with Supabase
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spaceXxl),

                // Logo/Title
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.shield_tick5,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      const Text(
                        'Family Emergency Hub',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      const Text(
                        'Keep your family safe & connected',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
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
                    )
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: AppAnimations.medium,
                      curve: AppAnimations.scaleUp,
                    ),

                const SizedBox(height: AppTheme.spaceXxl),

                // Welcome text
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
                    .animate(delay: 100.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXs),

                const Text(
                  'Sign in to access your family hub',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate(delay: 150.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceXl),

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
                    .animate(delay: 200.ms)
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
                  hintText: 'Enter your password',
                  prefixIcon: Iconsax.lock,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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

                const SizedBox(height: AppTheme.spaceSm),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.forgotPassword),
                    child: const Text('Forgot password?'),
                  ),
                )
                    .animate(delay: 300.ms)
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: AppAnimations.medium,
                      curve: AppAnimations.slideIn,
                    ),

                const SizedBox(height: AppTheme.spaceLg),

                // Login button
                PrimaryButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                )
                    .animate(delay: 350.ms)
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

                const SizedBox(height: AppTheme.spaceXl),

                // Register link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(RouteNames.register),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: 400.ms)
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
