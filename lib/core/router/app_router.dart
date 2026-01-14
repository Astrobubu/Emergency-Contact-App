import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../animations/app_animations.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/family/presentation/screens/family_groups_screen.dart';
import '../../features/family/presentation/screens/family_member_detail_screen.dart';
import '../../features/family/presentation/screens/add_family_member_screen.dart';
import '../../features/contacts/presentation/screens/contacts_screen.dart';
import '../../features/location/presentation/screens/family_map_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/medical/presentation/screens/medical_hub_screen.dart';
import '../../features/documents/presentation/screens/documents_vault_screen.dart';
import '../../features/emergency/presentation/screens/emergency_trigger_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import 'route_names.dart';

/// Router provider with authentication state
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: true,
    routes: [
      // === AUTH ROUTES ===
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          slideFrom: AppAnimations.slideFromBottom,
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),

      // === MAIN APP SHELL ===
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          // Home
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            pageBuilder: (context, state) => _buildSlideTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),

          // Family
          GoRoute(
            path: RouteNames.family,
            name: 'family',
            pageBuilder: (context, state) => _buildSlideTransitionPage(
              key: state.pageKey,
              child: const FamilyGroupsScreen(),
            ),
          ),

          // Map
          GoRoute(
            path: RouteNames.map,
            name: 'map',
            pageBuilder: (context, state) => _buildSlideTransitionPage(
              key: state.pageKey,
              child: const FamilyMapScreen(),
            ),
          ),

          // Contacts
          GoRoute(
            path: RouteNames.contacts,
            name: 'contacts',
            pageBuilder: (context, state) => _buildSlideTransitionPage(
              key: state.pageKey,
              child: const ContactsScreen(),
            ),
          ),

          // Settings
          GoRoute(
            path: RouteNames.settings,
            name: 'settings',
            pageBuilder: (context, state) => _buildSlideTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),

      // === VAULT ROUTES (outside shell for full screen) ===
      GoRoute(
        path: RouteNames.medicalHub,
        name: 'medicalHub',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const MedicalHubScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.documentsVault,
        name: 'documentsVault',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const DocumentsVaultScreen(),
        ),
      ),

      // === FAMILY MEMBER ROUTES ===
      GoRoute(
        path: '/family/member/:id',
        name: 'familyMemberDetail',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: FamilyMemberDetailScreen(
            memberId: state.pathParameters['id']!,
          ),
        ),
      ),
      GoRoute(
        path: '/family/add',
        name: 'addFamilyMember',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          key: state.pageKey,
          child: const AddFamilyMemberScreen(),
        ),
      ),

      // === EMERGENCY ROUTES ===
      GoRoute(
        path: RouteNames.emergencyTrigger,
        name: 'emergencyTrigger',
        pageBuilder: (context, state) => _buildScaleTransitionPage(
          key: state.pageKey,
          child: const EmergencyTriggerScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Build page with fade + subtle slide transition (cleaner than full slide)
CustomTransitionPage _buildSlideTransitionPage({
  required LocalKey key,
  required Widget child,
  Offset slideFrom = const Offset(0.05, 0), // Subtle horizontal slide
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: AppAnimations.fast,
    reverseTransitionDuration: AppAnimations.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: slideFrom,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        ),
      );
    },
  );
}

/// Build page with scale transition (for modals/emergency screens)
CustomTransitionPage _buildScaleTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: AppAnimations.medium,
    reverseTransitionDuration: AppAnimations.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: AppAnimations.bounce,
          reverseCurve: AppAnimations.scaleDown,
        )),
        child: child,
      );
    },
  );
}
