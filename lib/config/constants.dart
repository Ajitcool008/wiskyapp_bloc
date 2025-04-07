import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'One Cask';
  static const String defaultFontFamily = 'EBGaramond';

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Local storage keys
  static const String storageKeyBottles = 'bottles';
  static const String storageKeyTastingNotes = 'tasting_notes';
  static const String storageKeyIsAuthenticated = 'is_authenticated';
  static const String storageKeyUserEmail = 'user_email';
}

class AppColors {
  static const Color primary = Color(0xFFD4AF37); // Gold color from the design
  static const Color background = Color(0xFF0F1923); // Dark blue background
  static const Color cardBackground = Color(
    0xFF152736,
  ); // Slightly lighter blue for cards
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFF333333);
  static const Color error = Colors.red;
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String backgroundPattern =
      'assets/images/background_pattern.png';
  static const String springbankBottle = 'assets/images/springbank.png';
  static const String taliskerBottle = 'assets/images/talisker.png';

  // Icons
  static const String iconScan = 'assets/icons/scan.png';
  static const String iconCollection = 'assets/icons/collection.png';
  static const String iconShop = 'assets/icons/shop.png';
  static const String iconSettings = 'assets/icons/settings.png';
}

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.primary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppConstants.defaultFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.primary,
  );
}

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String collection = '/collection';
  static const String bottleDetails = '/bottle-details';
  static const String tastingNotes = '/tasting-notes';
  static const String history = '/history';
}
