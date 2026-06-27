class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Enter valid email';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number required';
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length != 10) return 'Phone number must be 10 digits';
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleaned)) {
      return 'Enter a valid Indian mobile number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    if (value.length < 6) return 'Min 6 characters required';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName required';
    return null;
  }
}
