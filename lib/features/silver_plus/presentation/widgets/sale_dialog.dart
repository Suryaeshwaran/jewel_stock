import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Opened either:
/// - by tapping an Available box (create mode, pass [box]) — Box ID is
///   read-only. Blocks the sale if Count or Weight exceeds what's
///   currently in the box.
/// - by tapping Edit on a Sold row (edit mode, pass [existingSale]) — the
///   box itself can't be changed, but count/weight/date can. Editing
///   restocks the box for the old amounts before validating the new ones,
///   so the box always reflects the corrected sale.
class SaleDialog extends StatefulWidget {
  const SaleDialog({super.key, this.box, this.existingSale})
      : assert(
          box != null || existingSale != null,
          'Provide either box (create) or existingSale (edit)',
        );

  /// Provided when selling from the Available tab (create mode).
  final SilverPlusBox? box;

  /// Provided when editing a sale from the Sold tab (edit mode).
  final SilverPlusSaleRow? existingSale;

  bool get isEditing => existingSale != null;

  @override
  State<SaleDialog> createState() => _SaleDialogState();
}

class _SaleDialogState extends State<SaleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  late final _countController = TextEditingController(
    text: widget.existingSale?.countSold.toString() ?? '',
  );
  late final _weightController = TextEditingController(
    text: widget.existingSale?.weightSoldGrams.toString() ?? '',
  );
  late DateTime _saleDate = widget.existingSale?.saleDate ?? DateTime.now();

  // In edit mode the sale row only carries boxId/boxCode — fetch the live
  // box so we can show current stock and validate against it. In create
  // mode the box was already passed in, so just wrap it in a Future.
  late final Future<SilverPlusBox> _boxFuture =
      widget.isEditing ? _db.boxById(widget.existingSale!.boxId) : Future.value(widget.box);

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

    final countSold = int.parse(_countController.text);
    final weightSoldGrams = double.parse(_weightController.text);

    final success = widget.isEditing
        ? await _db.updateSale(
            saleId: widget.existingSale!.id,
            newCountSold: countSold,
            newWeightSoldGrams: weightSoldGrams,
            newSaleDate: _saleDate,
          )
        : await _db.sellFromBox(
            boxId: box.id,
            countSold: countSold,
            weightSoldGrams: weightSoldGrams,
            saleDate: _saleDate,
          );

    if (!success) {
      // In edit mode, what's "available" also includes this sale's own
      // old amounts, since editing reverts them before re-validating.
      final availableCount =
          widget.isEditing ? box.count + widget.existingSale!.countSold : box.count;
      final availableWeight =
          widget.isEditing ? box.weightGrams + widget.existingSale!.weightSoldGrams : box.weightGrams;
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

        return AlertDialog(
          title: Text(widget.isEditing ? 'Edit Sale' : 'Sell from Box'),
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
                        ? 'Available if this sale is undone: '
                            '${box.count + widget.existingSale!.countSold} pcs · '
                            '${box.weightGrams + widget.existingSale!.weightSoldGrams}g'
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