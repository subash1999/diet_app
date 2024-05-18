
class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the email is valid
  }
}

class DateValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
    // Regular expression for date validation (format: YYYY-MM-DD)
    final RegExp dobRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dobRegex.hasMatch(value)) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }

    // Validate the date components
    try {
      final parts = value.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Check if the year, month, and day are within valid ranges
      if (year < 1900 || year > DateTime.now().year) {
        return 'Please enter a valid year (between 1900 and ${DateTime.now().year})';
      }
      if (month < 1 || month > 12) {
        return 'Please enter a valid month (between 01 and 12)';
      }
      if (day < 1 || day > 31) {
        return 'Please enter a valid day (between 01 and 31)';
      }

      // Additional validation logic can be added here if needed
    } catch (e) {
      return 'Invalid date format';
    }

    return null; // Return null if the date is valid
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final RegExp lengthRegex = RegExp(r'^.{8,}$'); // At least 8 characters
    final RegExp digitRegex = RegExp(r'\d'); // At least one digit
    final RegExp uppercaseRegex =
        RegExp(r'[A-Z]'); // At least one uppercase letter
    final RegExp lowercaseRegex =
        RegExp(r'[a-z]'); // At least one lowercase letter
    final RegExp symbolRegex =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'); // At least one special character

    if (!lengthRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters long';
    }

    if (!digitRegex.hasMatch(value)) {
      return 'Password must contain at least one digit';
    }

    if (!uppercaseRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!lowercaseRegex.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!symbolRegex.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null; // Password is valid
  }
}
