import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Adds new stock into an existing box. Shows the box's current
/// count/weight for context, takes the amount being added, and
/// silently updates the box — no history is kept for refills.
class RefillDialog extends StatefulWidget {
  const RefillDialog({super.key, required this.box});

  final SilverPlusBox box;

  @override
  State<RefillDialog> createState() => _RefillDialogState();
}

class _RefillDialogState extends State<RefillDialog> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  final _countController = TextEditingController();
  final _weightController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _countController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await _db.refillBox(
      boxId: widget.box.id,
      addCount: int.parse(_countController.text),
      addWeightGrams: double.parse(_weightController.text),
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Refill Box'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Box', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  widget.box.boxCode,
                  style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Current: ${widget.box.count} pcs · ${widget.box.weightGrams}g',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countController,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Add Count'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter count to add';
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
                decoration: const InputDecoration(labelText: 'Add Weight (grams)'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter weight to add';
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
          child: Text(_saving ? 'Saving…' : 'Refill'),
        ),
      ],
    );
  }
}