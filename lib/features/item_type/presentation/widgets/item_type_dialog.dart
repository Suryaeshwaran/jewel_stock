import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_colors.dart';

/// Forces all keystrokes to uppercase as the user types.
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Used for both "Add Type" and "Edit Type". Pass [existingNames] (lower-
/// cased) so we can block duplicates within the same group before hitting
/// the DB's unique constraint.
class ItemTypeDialog extends StatefulWidget {
  const ItemTypeDialog({
    super.key,
    required this.groupLabel,
    required this.existingNamesLower,
    this.initialName,
  });

  final String groupLabel;
  final Set<String> existingNamesLower;
  final String? initialName;

  bool get isEditing => initialName != null;

  @override
  State<ItemTypeDialog> createState() => _ItemTypeDialogState();
}

class _ItemTypeDialogState extends State<ItemTypeDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: (widget.initialName ?? '').toUpperCase());
  String? _error;

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Enter a type name');
      return;
    }
    final lower = value.toLowerCase();
    final isSameAsOriginal = widget.initialName?.toLowerCase() == lower;
    if (!isSameAsOriginal && widget.existingNamesLower.contains(lower)) {
      setState(() => _error = 'This type already exists for ${widget.groupLabel}');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Item Type' : 'Add Item Type — ${widget.groupLabel}'),
      content: SizedBox(
        width: 360,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [_UpperCaseTextFormatter()],
          decoration: InputDecoration(
            labelText: 'Type name',
            hintText: 'e.g. CHAIN, RING, BANGLE',
            errorText: _error,
          ),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

/// Small confirm dialog reused for delete actions.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusScrapped),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}