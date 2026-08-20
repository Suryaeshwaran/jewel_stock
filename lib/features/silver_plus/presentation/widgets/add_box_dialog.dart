import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

class BoxDialog extends StatefulWidget {
  const BoxDialog({super.key, this.existing});

  final SilverPlusBox? existing;

  @override
  State<BoxDialog> createState() => _BoxDialogState();
}

class _BoxDialogState extends State<BoxDialog> {
  final _formKey = GlobalKey<FormState>();
  final _boxCodeController = TextEditingController();
  final _countController = TextEditingController();
  final _weightController = TextEditingController();
  
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _boxCodeController.text = widget.existing!.boxCode;
      _countController.text = widget.existing!.count.toString();
      _weightController.text = widget.existing!.weightGrams.toString();
      // Use existing box creation/update date or default to today
      _selectedDate = widget.existing!.createdAt;
    } else {
      _selectedDate = DateTime.now(); // Defaults to today
    }
  }

  @override
  void dispose() {
    _boxCodeController.dispose();
    _countController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final db = context.read<AppDatabase>();
    final code = _boxCodeController.text.trim();
    final count = int.parse(_countController.text.trim());
    final weight = double.parse(_weightController.text.trim());

    // Check duplicate code
    final isTaken = await db.isBoxCodeTaken(
      code,
      excludingId: widget.existing?.id,
    );

    if (isTaken && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Box ID "$code" is already taken.')),
      );
      return;
    }

    if (widget.existing == null) {
      await db.addBox(
        SilverPlusBoxesCompanion.insert(
          boxCode: code,
          count: count,
          weightGrams: weight,
          createdAt: Value(_selectedDate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await db.updateBox(
        widget.existing!.id,
        SilverPlusBoxesCompanion(
          boxCode: Value(code),
          count: Value(count),
          weightGrams: Value(weight),
          createdAt: Value(_selectedDate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Box' : 'Edit Box'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _boxCodeController,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  UpperCaseTextFormatter(),
                ],
                decoration: const InputDecoration(labelText: 'Box ID / Code'),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Enter Box ID' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Count (Pcs)'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter count';
                  if (int.tryParse(val.trim()) == null) return 'Enter a valid integer';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (Grams)'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter weight';
                  if (double.tryParse(val.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(_selectedDate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(widget.existing == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}