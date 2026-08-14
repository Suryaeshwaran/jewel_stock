import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Allowed transitions, per the confirmed rules:
/// - available -> sold, pending, scrapped
/// - pending   -> available, sold, scrapped
/// - sold      -> available (revert only)
/// - scrapped  -> terminal, no transitions
List<OrnamentStatus> _allowedTargets(OrnamentStatus current) {
  switch (current) {
    case OrnamentStatus.available:
      return [OrnamentStatus.sold, OrnamentStatus.pending, OrnamentStatus.scrapped];
    case OrnamentStatus.pending:
      return [OrnamentStatus.available, OrnamentStatus.sold, OrnamentStatus.scrapped];
    case OrnamentStatus.sold:
      return [OrnamentStatus.available];
    case OrnamentStatus.scrapped:
      return [];
  }
}

String _statusLabel(OrnamentStatus status) {
  switch (status) {
    case OrnamentStatus.available:
      return 'Available';
    case OrnamentStatus.sold:
      return 'Sold';
    case OrnamentStatus.pending:
      return 'Pending';
    case OrnamentStatus.scrapped:
      return 'Scrapped';
  }
}

/// Shown when tapping an ornament's ID. Current status is shown for
/// context only (not selectable). Returns true via Navigator.pop if a
/// change was made, so the caller can show a confirmation snackbar.
Future<bool?> showStatusChangeDialog(BuildContext context, Ornament ornament) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _StatusChangeDialog(ornament: ornament),
  );
}

class _StatusChangeDialog extends StatefulWidget {
  const _StatusChangeDialog({required this.ornament});

  final Ornament ornament;

  @override
  State<_StatusChangeDialog> createState() => _StatusChangeDialogState();
}

class _StatusChangeDialogState extends State<_StatusChangeDialog> {
  late final List<OrnamentStatus> _targets = _allowedTargets(widget.ornament.status);
  OrnamentStatus? _selected;
  DateTime _date = DateTime.now();
  final _customerController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _confirm() async {
    if (_selected == null) return;

    setState(() => _saving = true);
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.changeStatus(
      ornamentId: widget.ornament.id,
      newStatus: _selected!,
      date: _date,
      customerName: _selected == OrnamentStatus.pending
          ? (_customerController.text.trim().isEmpty ? null : _customerController.text.trim())
          : null,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_targets.isEmpty) {
      return AlertDialog(
        title: const Text('Scrapped'),
        content: const Text('This ornament is scrapped and its status can\'t be changed.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.headlineMedium,
          children: [
            const TextSpan(text: 'Update Status — '),
            TextSpan(
              text: widget.ornament.ornamentCode,
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current status: ${_statusLabel(widget.ornament.status)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ..._targets.map(
                (status) => RadioListTile<OrnamentStatus>(
                  contentPadding: EdgeInsets.zero,
                  value: status,
                  groupValue: _selected,
                  activeColor: AppColors.gold,
                  title: Text(_statusLabel(status)),
                  onChanged: (value) => setState(() => _selected = value),
                ),
              ),
              if (_selected != null) ...[
                const Divider(height: 24),
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
                        Text(DateFormat('dd MMM yyyy').format(_date)),
                        const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.gold),
                      ],
                    ),
                  ),
                ),
                if (_selected == OrnamentStatus.pending) ...[
                  const SizedBox(height: 16),
                  Text('Customer', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _customerController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: const InputDecoration(hintText: 'CUSTOMER NAME'),
                  ),
                ],
                const SizedBox(height: 16),
                Text('Ornament ID', style: Theme.of(context).textTheme.labelMedium),
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
                    widget.ornament.ornamentCode,
                    style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
                  ),
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
          onPressed: (_selected == null || _saving) ? null : _confirm,
          child: Text(_saving ? 'Saving…' : 'Confirm'),
        ),
      ],
    );
  }
}