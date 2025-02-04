class Validation {
  /// Ensure password is valid
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Ensure email is valid
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Email is invalid';
    } else if (!value.contains('.')) {
      return 'Email is invalid';
    }
    return null;
  }

  /// Ensure name is not empty
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }
  // validate systolic and diastolic values

  bool validateSystolicDiastolic(String systolic, String diastolic) {
    try {
      if (systolic.isEmpty || diastolic.isEmpty) {
        return false;
      } else if (double.tryParse(systolic) == null ||
          double.tryParse(diastolic) == null) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  bool validateTime(String hours, String minutes) {
    try {
      if (hours.isEmpty || minutes.isEmpty) {
        return false;
      } else if (int.tryParse(hours) == null || int.tryParse(minutes) == null) {
        return false;
      } else if (int.parse(hours) < 0 ||
          int.parse(hours) > 12 ||
          int.parse(minutes) < 0 ||
          int.parse(minutes) > 59) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
