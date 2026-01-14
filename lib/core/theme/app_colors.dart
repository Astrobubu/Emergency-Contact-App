import 'package:flutter/material.dart';

/// Beige/Warm Cozy Color Palette for Family Emergency Hub
class AppColors {
  AppColors._();

  // === PRIMARY - WARM TAN/BEIGE ===
  static const Color primary = Color(0xFFD4A574);
  static const Color primaryLight = Color(0xFFE8C9A6);
  static const Color primaryDark = Color(0xFFB8865C);
  static const Color primaryContainer = Color(0xFFF5E6D8);

  // === SECONDARY - SOFT TERRACOTTA ===
  static const Color secondary = Color(0xFFE07A5F);
  static const Color secondaryLight = Color(0xFFF4A896);
  static const Color secondaryDark = Color(0xFFC45D43);
  static const Color secondaryContainer = Color(0xFFFFE4DC);

  // === BACKGROUND & SURFACE - CREAM/OFF-WHITE ===
  static const Color background = Color(0xFFFAF6F1);
  static const Color surface = Color(0xFFFFFBF7);
  static const Color surfaceVariant = Color(0xFFF5EDE4);
  static const Color surfaceDim = Color(0xFFEFE6DB);

  // === TEXT COLORS ===
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF9B9B9B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // === ACCENT/STATUS COLORS ===
  static const Color success = Color(0xFF81B29A);
  static const Color successLight = Color(0xFFB8D4C7);
  static const Color successDark = Color(0xFF5E8F75);

  static const Color warning = Color(0xFFF2CC8F);
  static const Color warningLight = Color(0xFFF9E4C4);
  static const Color warningDark = Color(0xFFD9A84A);

  static const Color error = Color(0xFFE07A5F);
  static const Color errorLight = Color(0xFFF4A896);
  static const Color errorDark = Color(0xFFC45D43);

  // === EMERGENCY - TRUE RED ===
  static const Color emergency = Color(0xFFDC3545);
  static const Color emergencyLight = Color(0xFFFF6B7A);
  static const Color emergencyDark = Color(0xFFB02A37);
  static const Color emergencyPulse = Color(0xFFFF4757);

  // === INFO ===
  static const Color info = Color(0xFF7FB3D5);
  static const Color infoLight = Color(0xFFB3D4E8);
  static const Color infoDark = Color(0xFF5A9BC9);

  // === NEUTRALS ===
  static const Color divider = Color(0xFFE8E0D5);
  static const Color border = Color(0xFFD9CEC0);
  static const Color borderLight = Color(0xFFEAE2D8);
  static const Color shadow = Color(0x1A3D3D3D);
  static const Color shadowMedium = Color(0x333D3D3D);

  // === OVERLAY ===
  static const Color scrim = Color(0x803D3D3D);
  static const Color overlay = Color(0x4D3D3D3D);

  // === SPECIAL ===
  static const Color shimmerBase = Color(0xFFEFE6DB);
  static const Color shimmerHighlight = Color(0xFFFAF6F1);

  // === GRADIENTS ===
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [emergencyLight, emergency, emergencyDark],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF6F1), Color(0xFFF5EDE4)],
  );
}
