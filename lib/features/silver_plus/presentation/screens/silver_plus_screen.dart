import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../item_type/presentation/widgets/item_type_dialog.dart' show showConfirmDialog;
import '../../../../core/utils/text_formatters.dart';
import '../widgets/add_box_dialog.dart';
import '../widgets/refill_dialog.dart';
import '../widgets/sale_dialog.dart';
import '../widgets/pending_dialog.dart';

class SilverPlusScreen extends StatefulWidget {
  const SilverPlusScreen({super.key});

  @override
  State<SilverPlusScreen> createState() => _SilverPlusScreenState();
}

class _SilverPlusScreenState extends State<SilverPlusScreen>
    with SingleTickerProviderStateMixin {
  late final AppDatabase _db = context.read<AppDatabase>();
  late final TabController _tabController = TabController(length: 3, vsync: this);

  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addBox() async {
    await showDialog<bool>(context: context, builder: (_) => const BoxDialog());
  }

  Future<void> _refill(SilverPlusBox box) async {
    await showDialog<bool>(context: context, builder: (_) => RefillDialog(box: box));
  }

  Future<void> _editBox(SilverPlusBox box) async {
    await showDialog<bool>(context: context, builder: (_) => BoxDialog(existing: box));
  }

  Future<void> _deleteBox(SilverPlusBox box) async {
    final allocCount = await _db.countAllocationsOfBox(box.id);
    if (!mounted) return;

    if (allocCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Can\'t delete this box'),
          content: Text(
            'This box has $allocCount pending/sold ${allocCount == 1 ? 'record' : 'records'}. '
            'It can\'t be deleted since that would break that history.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete "${box.boxCode}"?',
      message: 'This can\'t be undone.',
    );
    if (confirmed) {
      await _db.deleteBox(box.id);
    }
  }

  /// Tapping an Available box: choose whether this chunk goes to
  /// Pending or straight to Sold.
  Future<void> _chooseFromAvailable(SilverPlusBox box) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Choose Action'),
        children: [
          _BoxCodeHeader(boxCode: box.boxCode),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('pending'),
            child: const ListTile(
              leading: Icon(Icons.hourglass_empty_rounded, color: AppColors.gold),
              title: Text('Move to Pending'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('sold'),
            child: const ListTile(
              leading: Icon(Icons.sell_outlined, color: AppColors.gold),
              title: Text('Sell'),
            ),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;

    if (choice == 'pending') {
      final saved = await showDialog<bool>(
        context: context,
        builder: (_) => PendingDialog(box: box),
      );
      if (saved == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Moved to Pending')),
        );
      }
    } else {
      final sold = await showDialog<bool>(
        context: context,
        builder: (_) => SaleDialog(box: box),
      );
      if (sold == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale recorded')),
        );
      }
    }
  }

  /// Tapping a Pending row: choose Available (revert) or Sold (convert).
  Future<void> _chooseFromPending(SilverPlusAllocationRow row) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Choose Action'),
        children: [
          _BoxCodeHeader(boxCode: row.boxCode),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('available'),
            child: const ListTile(
              leading: Icon(Icons.undo_rounded, color: AppColors.gold),
              title: Text('Move back to Available'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('sold'),
            child: const ListTile(
              leading: Icon(Icons.sell_outlined, color: AppColors.gold),
              title: Text('Mark as Sold'),
            ),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;

    if (choice == 'available') {
      await _revertToAvailable(row);
    } else {
      final saved = await showDialog<bool>(
        context: context,
        builder: (_) => SaleDialog(existingAllocation: row),
      );
      if (saved == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marked as Sold')),
        );
      }
    }
  }

  /// Tapping a Sold row: choose Available (revert) or Pending (convert).
  Future<void> _chooseFromSold(SilverPlusAllocationRow row) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Choose Action'),
        children: [
          _BoxCodeHeader(boxCode: row.boxCode),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('available'),
            child: const ListTile(
              leading: Icon(Icons.undo_rounded, color: AppColors.gold),
              title: Text('Move back to Available'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('pending'),
            child: const ListTile(
              leading: Icon(Icons.hourglass_empty_rounded, color: AppColors.gold),
              title: Text('Mark as Pending'),
            ),
          ),
        ],
      ),
    );
    if (!mounted || choice == null) return;

    if (choice == 'available') {
      await _revertToAvailable(row);
    } else {
      final saved = await showDialog<bool>(
        context: context,
        builder: (_) => PendingDialog(existingAllocation: row),
      );
      if (saved == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Marked as Pending')),
        );
      }
    }
  }

  Future<void> _revertToAvailable(SilverPlusAllocationRow row) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Move back to Available?',
      message: '${row.count} pcs · ${row.weightGrams}g will be added back to box ${row.boxCode}.',
    );
    if (confirmed) {
      await _db.revertAllocationToAvailable(row.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Moved back to Available')),
        );
      }
    }
  }

  Future<void> _editPending(SilverPlusAllocationRow row) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => PendingDialog(existingAllocation: row),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pending entry updated')),
      );
    }
  }

  Future<void> _editSold(SilverPlusAllocationRow row) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => SaleDialog(existingAllocation: row),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale updated')),
      );
    }
  }

  Future<void> _deleteSold(SilverPlusAllocationRow row) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this sale?',
      message: '${row.count} pcs · ${row.weightGrams}g from ${row.boxCode} on '
          '${DateFormat('dd MMM yyyy').format(row.date)}. '
          'The box\'s stock will NOT be restored. This can\'t be undone.',
    );
    if (confirmed) {
      await _db.deleteAllocation(row.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Silver+(Boxes)')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.onGold,
        icon: const Icon(Icons.add),
        label: const Text('Add Box'),
        onPressed: _addBox,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by Box ID',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [Tab(text: 'Available'), Tab(text: 'Pending'), Tab(text: 'Sold')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AvailableTab(
                  db: _db,
                  search: _search,
                  onChoose: _chooseFromAvailable,
                  onRefill: _refill,
                  onEdit: _editBox,
                  onDelete: _deleteBox,
                ),
                _PendingTab(
                  db: _db,
                  search: _search,
                  onChoose: _chooseFromPending,
                  onEdit: _editPending,
                ),
                _SoldTab(
                  db: _db,
                  search: _search,
                  onChoose: _chooseFromSold,
                  onEdit: _editSold,
                  onDelete: _deleteSold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableTab extends StatelessWidget {
  const _AvailableTab({
    required this.db,
    required this.search,
    required this.onChoose,
    required this.onRefill,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase db;
  final String search;
  final ValueChanged<SilverPlusBox> onChoose;
  final ValueChanged<SilverPlusBox> onRefill;
  final ValueChanged<SilverPlusBox> onEdit;
  final ValueChanged<SilverPlusBox> onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SilverPlusBox>>(
      stream: db.watchAvailableBoxes(searchTerm: search),
      builder: (context, snapshot) {
        final boxes = snapshot.data ?? const <SilverPlusBox>[];

        if (boxes.isEmpty) {
          return Center(
            child: Text('No boxes here yet.', style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          itemCount: boxes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final box = boxes[index];
            final theme = Theme.of(context);

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onChoose(box),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          box.boxCode,
                          style: theme.textTheme.titleMedium?.copyWith(color: AppColors.gold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${box.count} pcs', style: theme.textTheme.bodyMedium),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${box.weightGrams}g',
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box_outlined, size: 18),
                        color: AppColors.gold,
                        tooltip: 'Refill',
                        onPressed: () => onRefill(box),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: AppColors.gold,
                        tooltip: 'Edit',
                        onPressed: () => onEdit(box),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: AppColors.statusScrapped,
                        tooltip: 'Delete',
                        onPressed: () => onDelete(box),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PendingTab extends StatelessWidget {
  const _PendingTab({
    required this.db,
    required this.search,
    required this.onChoose,
    required this.onEdit,
  });

  final AppDatabase db;
  final String search;
  final ValueChanged<SilverPlusAllocationRow> onChoose;
  final ValueChanged<SilverPlusAllocationRow> onEdit;

  Future<void> _editCustomer(BuildContext context, SilverPlusAllocationRow row) async {
    final updated = await showDialog<String>(
      context: context,
      builder: (_) => _EditAllocationCustomerDialog(initialName: row.customerName ?? ''),
    );
    if (updated == null) return;

    // Customer-only edit: keep count/weight/date/status as-is, just
    // swap the customer name.
    await db.updateAllocation(
      allocationId: row.id,
      newCount: row.count,
      newWeightGrams: row.weightGrams,
      newDate: row.date,
      newCustomerName: updated.trim().isEmpty ? null : updated.trim(),
      newStatus: AllocationStatus.pending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SilverPlusAllocationRow>>(
      stream: db.watchAllocations(status: AllocationStatus.pending, searchTerm: search),
      builder: (context, snapshot) {
        final rows = snapshot.data ?? const <SilverPlusAllocationRow>[];

        if (rows.isEmpty) {
          return Center(
            child: Text('No pending entries yet.', style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final row = rows[index];
            final theme = Theme.of(context);

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onChoose(row),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.boxCode,
                          style: theme.textTheme.titleMedium?.copyWith(color: AppColors.gold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${row.count} pcs', style: theme.textTheme.bodyMedium),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          DateFormat('dd MMM yyyy').format(row.date),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () => _editCustomer(context, row),
                          child: Text(
                            (row.customerName == null || row.customerName!.trim().isEmpty)
                                ? '—'
                                : row.customerName!,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gold.withOpacity(0.4),
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${row.weightGrams}g',
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: AppColors.gold,
                        tooltip: 'Edit',
                        onPressed: () => onEdit(row),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SoldTab extends StatelessWidget {
  const _SoldTab({
    required this.db,
    required this.search,
    required this.onChoose,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase db;
  final String search;
  final ValueChanged<SilverPlusAllocationRow> onChoose;
  final ValueChanged<SilverPlusAllocationRow> onEdit;
  final ValueChanged<SilverPlusAllocationRow> onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SilverPlusAllocationRow>>(
      stream: db.watchAllocations(status: AllocationStatus.sold, searchTerm: search),
      builder: (context, snapshot) {
        final rows = snapshot.data ?? const <SilverPlusAllocationRow>[];

        if (rows.isEmpty) {
          return Center(
            child: Text('No sales recorded yet.', style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final row = rows[index];
            final theme = Theme.of(context);

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onChoose(row),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.boxCode,
                          style: theme.textTheme.titleMedium?.copyWith(color: AppColors.gold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${row.count} pcs', style: theme.textTheme.bodyMedium),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          DateFormat('dd MMM yyyy').format(row.date),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${row.weightGrams}g',
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: AppColors.gold,
                        tooltip: 'Edit',
                        onPressed: () => onEdit(row),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: AppColors.statusScrapped,
                        tooltip: 'Delete',
                        onPressed: () => onDelete(row),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Consistent box-code header shown at the top of the three "choose
/// action" dialogs (Available/Pending/Sold row tap). Gives the box code
/// its own labeled, fixed-font block instead of mixing it into the
/// dialog title, matching the style used in SaleDialog/PendingDialog/
/// RefillDialog.
class _BoxCodeHeader extends StatelessWidget {
  const _BoxCodeHeader({required this.boxCode});

  final String boxCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Text(
          boxCode,
          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Simple single-field dialog for editing the Customer name on a
/// Pending allocation. Forces uppercase, matching the Customer field
/// used elsewhere (Ornaments' pending flow, the Pending dialog).
class _EditAllocationCustomerDialog extends StatefulWidget {
  const _EditAllocationCustomerDialog({required this.initialName});

  final String initialName;

  @override
  State<_EditAllocationCustomerDialog> createState() =>
      _EditAllocationCustomerDialogState();
}

class _EditAllocationCustomerDialogState extends State<_EditAllocationCustomerDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName.toUpperCase());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Customer'),
      content: SizedBox(
        width: 340,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: const InputDecoration(hintText: 'CUSTOMER NAME'),
          onSubmitted: (_) => Navigator.of(context).pop(_controller.text),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}