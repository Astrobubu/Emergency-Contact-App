import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Animation constants and utilities for Family Emergency Hub
/// NO FADING - Uses slide, scale, bounce, and spring physics
class AppAnimations {
  AppAnimations._();

  // === DURATION CONSTANTS ===
  static const Duration fastest = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slowest = Duration(milliseconds: 550);

  // === DELAY CONSTANTS (for staggered animations) ===
  static const Duration staggerDelay = Duration(milliseconds: 30);
  static const Duration staggerDelayLong = Duration(milliseconds: 60);

  // === CURVE CONSTANTS ===

  /// Smooth slide in - for page transitions
  static const Curve slideIn = Curves.easeOutCubic;

  /// Smooth slide out - for dismissals
  static const Curve slideOut = Curves.easeInCubic;

  /// Bounce effect - for buttons and interactive elements
  static const Curve bounce = Curves.elasticOut;

  /// Gentle bounce - less extreme than elasticOut
  static const Curve gentleBounce = Curves.easeOutBack;

  /// Scale up - for appearing elements
  static const Curve scaleUp = Curves.easeOutBack;

  /// Scale down - for disappearing elements
  static const Curve scaleDown = Curves.easeInBack;

  /// Spring effect - for natural motion
  static const Curve spring = Curves.easeOutExpo;

  /// Snap - quick decisive motion
  static const Curve snap = Curves.easeOutQuart;

  // === SPRING SIMULATION ===

  /// Default spring physics for natural motion
  static SpringDescription get defaultSpring => const SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 20.0,
  );

  /// Bouncy spring for playful interactions
  static SpringDescription get bouncySpring => const SpringDescription(
    mass: 1.0,
    stiffness: 400.0,
    damping: 15.0,
  );

  /// Stiff spring for quick snaps
  static SpringDescription get stiffSpring => const SpringDescription(
    mass: 1.0,
    stiffness: 500.0,
    damping: 25.0,
  );

  /// Loose spring for gentle motion
  static SpringDescription get looseSpring => const SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 18.0,
  );

  // === OFFSET VALUES ===

  /// Standard slide from right
  static const Offset slideFromRight = Offset(1.0, 0.0);

  /// Standard slide from left
  static const Offset slideFromLeft = Offset(-1.0, 0.0);

  /// Standard slide from bottom
  static const Offset slideFromBottom = Offset(0.0, 1.0);

  /// Standard slide from top
  static const Offset slideFromTop = Offset(0.0, -1.0);

  /// Subtle slide from right (for list items)
  static const Offset subtleSlideFromRight = Offset(0.3, 0.0);

  /// Subtle slide from bottom (for list items)
  static const Offset subtleSlideFromBottom = Offset(0.0, 0.2);

  // === SCALE VALUES ===

  /// Start small, end normal
  static const double scaleStart = 0.8;

  /// Subtle scale start
  static const double subtleScaleStart = 0.95;

  /// Scale for pressed state
  static const double pressedScale = 0.95;

  /// Scale for hover/focus state
  static const double focusScale = 1.02;
}

/// Custom spring curve for animation controllers
class SpringCurve extends Curve {
  final SpringDescription spring;

  const SpringCurve({
    this.spring = const SpringDescription(
      mass: 1.0,
      stiffness: 300.0,
      damping: 20.0,
    ),
  });

  @override
  double transform(double t) {
    final simulation = SpringSimulation(spring, 0.0, 1.0, 0.0);
    return simulation.x(t * simulation.dx(0).abs() / 10);
  }
}

/// Extension methods for easier animation usage
extension AnimationExtensions on Widget {
  /// Wrap widget with slide transition
  Widget slideTransition({
    required Animation<double> animation,
    Offset begin = AppAnimations.slideFromRight,
    Offset end = Offset.zero,
    Curve curve = AppAnimations.slideIn,
  }) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: this,
    );
  }

  /// Wrap widget with scale transition
  Widget scaleTransition({
    required Animation<double> animation,
    double begin = AppAnimations.scaleStart,
    double end = 1.0,
    Curve curve = AppAnimations.scaleUp,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(parent: animation, curve: curve),
      ),
      child: this,
    );
  }
}
