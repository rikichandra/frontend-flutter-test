import 'package:flutter/services.dart';
import '../utils/helpers.dart';

/// Custom text input formatter for salary input with thousand separators
class SalaryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return it as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove any non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // If no digits, return empty
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Format with thousand separators
    String formatted = Helpers.formatNumberWithSeparator(digits);

    // Calculate the new cursor position
    int newOffset = formatted.length;

    // If user is typing (adding characters), place cursor at the end
    if (newValue.text.length > oldValue.text.length) {
      newOffset = formatted.length;
    } else {
      // If user is deleting, try to maintain relative cursor position
      int oldCursorPos = oldValue.selection.baseOffset;
      int digitsBeforeCursor = oldValue.text
          .substring(0, oldCursorPos.clamp(0, oldValue.text.length))
          .replaceAll(RegExp(r'\D'), '')
          .length;

      // Count characters in formatted string up to digitsBeforeCursor
      int charCount = 0;
      int digitCount = 0;
      for (int i = 0; i < formatted.length && digitCount < digitsBeforeCursor; i++) {
        charCount++;
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitCount++;
        }
      }
      newOffset = charCount;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset.clamp(0, formatted.length)),
    );
  }
}
