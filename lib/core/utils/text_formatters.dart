import 'package:flutter/services.dart';

/// Forces uppercase but allows any character (spaces, punctuation) —
/// used for free-text fields like Customer name.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Strips anything that isn't a letter or digit, and forces uppercase,
/// as the user types. Used for the Ornament ID field.
class AlphanumericUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final cleaned = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final lengthDiff = newValue.text.length - cleaned.length;
    final newOffset = (newValue.selection.end - lengthDiff).clamp(0, cleaned.length);
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

/// Allows digits and a single decimal point, for the Weight field.
class DecimalTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (!RegExp(r'^\d*\.?\d{0,3}$').hasMatch(text)) {
      return oldValue;
    }
    return newValue;
  }
}