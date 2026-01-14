import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app_animations.dart';

/// Animated list item with staggered slide and scale animation
/// NO FADING - only slide and scale
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = AppAnimations.staggerDelay,
    this.duration = AppAnimations.medium,
    this.slideOffset = AppAnimations.subtleSlideFromRight,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay * index)
        .slideX(
          begin: slideOffset.dx,
          end: 0.0,
          duration: duration,
          curve: AppAnimations.slideIn,
        )
        .scale(
          begin: const Offset(AppAnimations.subtleScaleStart, AppAnimations.subtleScaleStart),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: AppAnimations.scaleUp,
        );
  }
}

/// Animated grid item with staggered scale and slide from bottom
class AnimatedGridItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;

  const AnimatedGridItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = AppAnimations.staggerDelay,
    this.duration = AppAnimations.medium,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay * index)
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: duration,
          curve: AppAnimations.slideIn,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: AppAnimations.scaleUp,
        );
  }
}

/// Bounce animation for interactive elements
class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  const BounceWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = AppAnimations.pressedScale,
    this.duration = AppAnimations.fast,
  });

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.snap,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Slide in widget from specified direction
class SlideInWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideFrom;
  final Curve curve;

  const SlideInWidget({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.slideFrom = AppAnimations.slideFromRight,
    this.curve = AppAnimations.slideIn,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .slideX(
          begin: slideFrom.dx,
          end: 0.0,
          duration: duration,
          curve: curve,
        )
        .slideY(
          begin: slideFrom.dy,
          end: 0.0,
          duration: duration,
          curve: curve,
        );
  }
}

/// Scale in widget with bounce effect
class ScaleInWidget extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double startScale;
  final Curve curve;

  const ScaleInWidget({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.startScale = AppAnimations.scaleStart,
    this.curve = AppAnimations.bounce,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .scale(
          begin: Offset(startScale, startScale),
          end: const Offset(1.0, 1.0),
          duration: duration,
          curve: curve,
        );
  }
}
