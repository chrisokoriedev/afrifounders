import '../constants/app_strings.dart';

/// Input validation utilities
class Validators {
  Validators._();

  /// Validates item title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.titleRequired;
    }
    if (value.length > 100) {
      return AppStrings.titleTooLong;
    }
    return null;
  }

  /// Validates item description
  static String? validateDescription(String? value) {
    if (value != null && value.length > 500) {
      return AppStrings.descriptionTooLong;
    }
    return null;
  }
}

