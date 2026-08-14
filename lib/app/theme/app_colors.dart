import 'package:flutter/material.dart';

/// JewelStock palette — light, "private bank statement" style.
///
/// Hard rule: never use a flat grey hex for TEXT. Secondary/muted text
/// uses the dedicated navy-based secondary/muted colors below, never a
/// generic grey hex.
class AppColors {
  AppColors._();

  // ---- Base surfaces (pure white page, cards separated by border+shadow) ----
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF2F0EA);

  // ---- Shadow (soft navy-tinted, used instead of grey drop shadows) ----
  static Color cardShadow = const Color(0xFF1C2B3A).withOpacity(0.08);

  // ---- Text (deep navy, hierarchy via distinct tones, never grey) ----
  static const Color textPrimary = Color(0xFF1C2B3A);
  static const Color textSecondary = Color(0xFF4A5A6A);
  static const Color textMuted = Color(0xFF8A8370);

  // ---- Gold accents ----
  static const Color gold = Color(0xFFA47C1B);
  static const Color goldLight = Color(0xFFC9A227);
  static const Color goldDark = Color(0xFF7A5C14);
  static const Color onGold = Color(0xFFFFFFFF);

  // ---- Silver / platinum accents ----
  static const Color silver = Color(0xFF5B6B7A);
  static const Color silverLight = Color(0xFF8393A2);
  static const Color platinum = Color(0xFF3E5266);

  // ---- Status colors ----
  static const Color statusAvailable = Color(0xFF2E7D5B);
  static const Color statusSold = Color(0xFF2F5FA3);
  static const Color statusPending = Color(0xFFB07A16);
  static const Color statusScrapped = Color(0xFFB0392F);

  static Color statusColor(String status) {
    switch (status) {
      case 'available':
        return statusAvailable;
      case 'sold':
        return statusSold;
      case 'pending':
        return statusPending;
      case 'scrapped':
        return statusScrapped;
      default:
        return textSecondary;
    }
  }

  // ---- Borders / dividers (darker now, to stay visible on pure white) ----
  static const Color divider = Color(0xFFE6E0D2);
  static const Color borderSubtle = Color(0xFFD9D2BF);
}