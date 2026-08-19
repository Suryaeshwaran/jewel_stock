import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Used for both adding and editing an Old Silver entry.
class OldSilverEntryDialog extends StatefulWidget {
  const OldSilverEntryDialog({super.key, this.existing});

  final OldSilverEntry? existing;

  bool get isEditing => existing != null;

  @override
  State<OldSilverEntryDialog> createState() => _OldSilverEntryDialogState();
}

class _OldSilverEntryDialogState extends State<OldSilverEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  late final TextEditingController _weightController = TextEditingController(
    text: widget.existing != null ? _trimZeros(widget.existing!.weightGrams) : '',
  );
  late final TextEditingController _noteController =
      TextEditingController(text: widget.existing?.note ?? '');
  late DateTime _entryDate = widget.existing?.entryDate ?? DateTime.now();

  bool _saving = false;

  String _trimZeros(double value) {
    var s = value.toStringAsFixed(3);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _entryDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final weight = double.parse(_weightController.text);
    final note = _noteController.text.trim();

    if (widget.isEditing) {
      await _db.updateOldSilverEntry(
        widget.existing!.id,
        OldSilverEntriesCompanion(
          weightGrams: Value(weight),
          entryDate: Value(_entryDate),
          note: Value(note.isEmpty ? null : note),
        ),
      );
    } else {
      await _db.addOldSilverEntry(
        OldSilverEntriesCompanion.insert(
          weightGrams: weight,
          entryDate: _entryDate,
          note: Value(note.isEmpty ? null : note),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Entry' : 'Add Entry'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _weightController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextFormatter()],
                decoration: const InputDecoration(labelText: 'Weight (grams)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter the weight';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Enter a valid weight';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Date', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(10),
                child: InputDecorator(
                  decoration: const InputDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd MMM yyyy').format(_entryDate)),
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.gold),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'e.g. old chain, melted',
                ),
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
