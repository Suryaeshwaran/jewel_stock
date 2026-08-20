import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Opened either:
/// - by choosing "Sell" from an Available box (create mode, pass [box])
///   — Box ID is read-only. Blocks the sale if Count or Weight exceeds
///   what's currently in the box.
/// - by the Edit icon on a Sold row, OR by choosing "Mark as Sold" from
///   a Pending row (edit/convert mode, pass [existingAllocation]) — the
///   box itself can't be changed. Saving always leaves the allocation
///   at status == sold, whether it started sold (plain edit — a no-op
///   status change) or started pending (a Pending -> Sold conversion).
///   Editing restocks the box for the row's OLD amounts before
///   validating the new ones, so the box always reflects the corrected
///   numbers.
class SaleDialog extends StatefulWidget {
  const SaleDialog({super.key, this.box, this.existingAllocation})
      : assert(
          box != null || existingAllocation != null,
          'Provide either box (create) or existingAllocation (edit/convert)',
        );

  /// Provided when selling from the Available tab (create mode).
  final SilverPlusBox? box;

  /// Provided when editing a Sold row, or converting a Pending row to
  /// Sold (edit/convert mode).
  final SilverPlusAllocationRow? existingAllocation;

  bool get isEditing => existingAllocation != null;

  @override
  State<SaleDialog> createState() => _SaleDialogState();
}

class _SaleDialogState extends State<SaleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  late final _countController = TextEditingController(
    text: widget.existingAllocation?.count.toString() ?? '',
  );
  late final _weightController = TextEditingController(
    text: widget.existingAllocation?.weightGrams.toString() ?? '',
  );
  late DateTime _saleDate = widget.existingAllocation?.date ?? DateTime.now();

  // In edit/convert mode the row only carries boxId/boxCode — fetch the
  // live box so we can show current stock and validate against it.
  late final Future<SilverPlusBox> _boxFuture = widget.isEditing
      ? _db.boxById(widget.existingAllocation!.boxId)
      : Future.value(widget.box);

  bool _saving = false;
  String? _formError;

  @override
  void dispose() {
    _countController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _saleDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _saleDate = picked);
  }

  Future<void> _submit(SilverPlusBox box) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _formError = null;
    });

    final count = int.parse(_countController.text);
    final weightGrams = double.parse(_weightController.text);

    final success = widget.isEditing
        ? await _db.updateAllocation(
            allocationId: widget.existingAllocation!.id,
            newCount: count,
            newWeightGrams: weightGrams,
            newDate: _saleDate,
            newStatus: AllocationStatus.sold,
          )
        : await _db.allocateFromBox(
            boxId: box.id,
            count: count,
            weightGrams: weightGrams,
            date: _saleDate,
            status: AllocationStatus.sold,
          );

    if (!success) {
      // "Available" here also includes this row's own old amounts in
      // edit/convert mode, since saving reverts them before re-validating.
      final availableCount =
          widget.isEditing ? box.count + widget.existingAllocation!.count : box.count;
      final availableWeight = widget.isEditing
          ? box.weightGrams + widget.existingAllocation!.weightGrams
          : box.weightGrams;
      setState(() {
        _saving = false;
        _formError =
            'Not enough stock in this box (available: $availableCount pcs, ${availableWeight}g)';
      });
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SilverPlusBox>(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AlertDialog(
            content: SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
          );
        }
        final box = snapshot.data!;
        final isConvertingFromPending =
            widget.isEditing && widget.existingAllocation!.status == AllocationStatus.pending;

        return AlertDialog(
          title: Text(
            !widget.isEditing
                ? 'Sell from Box'
                : (isConvertingFromPending ? 'Mark as Sold' : 'Edit Sale'),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: 380,
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
                      box.boxCode,
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isEditing
                        ? 'Available if this entry is undone: '
                            '${box.count + widget.existingAllocation!.count} pcs · '
                            '${box.weightGrams + widget.existingAllocation!.weightGrams}g'
                        : 'Currently: ${box.count} pcs · ${box.weightGrams}g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _countController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Count (of sale)'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Enter count sold';
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
                    decoration: const InputDecoration(labelText: 'Weight (sold, grams)'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Enter weight sold';
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
                          Text(DateFormat('dd MMM yyyy').format(_saleDate)),
                          const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.gold),
                        ],
                      ),
                    ),
                  ),
                  if (_formError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _formError!,
                      style: TextStyle(color: AppColors.statusScrapped, fontSize: 13),
                    ),
                  ],
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
              onPressed: _saving ? null : () => _submit(box),
              child: Text(_saving ? 'Saving…' : (widget.isEditing ? 'Save Changes' : 'Confirm Sale')),
            ),
          ],
        );
      },
    );
  }
}