import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Used for both "Add Box" and "Edit Box". Pass [existing] to edit a
/// box in place; leave it null to create a new one.
class BoxDialog extends StatefulWidget {
  const BoxDialog({super.key, this.existing});

  final SilverPlusBox? existing;

  bool get isEditing => existing != null;

  @override
  State<BoxDialog> createState() => _BoxDialogState();
}

class _BoxDialogState extends State<BoxDialog> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  late final TextEditingController _codeController =
      TextEditingController(text: widget.existing?.boxCode ?? '');
  late final TextEditingController _countController =
      TextEditingController(text: widget.existing?.count.toString() ?? '');
  late final TextEditingController _weightController =
      TextEditingController(text: widget.existing != null ? _trimZeros(widget.existing!.weightGrams) : '');

  String? _codeError;
  bool _saving = false;

  String _trimZeros(double value) {
    var s = value.toStringAsFixed(3);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _countController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _codeController.text.trim();
    setState(() {
      _saving = true;
      _codeError = null;
    });

    final taken = await _db.isBoxCodeTaken(code, excludingId: widget.existing?.id);
    if (taken) {
      setState(() {
        _saving = false;
        _codeError = 'This Box ID is already used';
      });
      return;
    }

    final count = int.parse(_countController.text);
    final weight = double.parse(_weightController.text);

    if (widget.isEditing) {
      await _db.updateBox(
        widget.existing!.id,
        SilverPlusBoxesCompanion(
          boxCode: Value(code),
          count: Value(count),
          weightGrams: Value(weight),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.addBox(
        SilverPlusBoxesCompanion.insert(
          boxCode: code,
          count: count,
          weightGrams: weight,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Box' : 'Add Box'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [AlphanumericUpperCaseFormatter()],
                decoration: InputDecoration(
                  labelText: 'Box ID',
                  hintText: 'e.g. SB1042',
                  errorText: _codeError,
                ),
                onChanged: (_) {
                  if (_codeError != null) setState(() => _codeError = null);
                },
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Enter a Box ID' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Count', hintText: 'e.g. 20'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter the count';
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Enter a valid count';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextFormatter()],
                decoration: const InputDecoration(labelText: 'Weight (grams)', hintText: 'e.g. 240.5'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter the weight';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Enter a valid weight';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'Saving…' : (widget.isEditing ? 'Save' : 'Add')),
        ),
      ],
    );
  }
}
