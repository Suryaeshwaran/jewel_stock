import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../item_type/presentation/widgets/item_type_dialog.dart' show showConfirmDialog;
import '../widgets/old_silver_entry_dialog.dart';

class OldSilverScreen extends StatelessWidget {
  const OldSilverScreen({super.key});

  Future<void> _addEntry(BuildContext context) async {
    await showDialog<bool>(context: context, builder: (_) => const OldSilverEntryDialog());
  }

  Future<void> _editEntry(BuildContext context, OldSilverEntry entry) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => OldSilverEntryDialog(existing: entry),
    );
  }

  Future<void> _deleteEntry(BuildContext context, AppDatabase db, OldSilverEntry entry) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this entry?',
      message: '${entry.weightGrams}g on ${DateFormat('dd MMM yyyy').format(entry.entryDate)}. '
          'This can\'t be undone.',
    );
    if (confirmed) {
      await db.deleteOldSilverEntry(entry.id);
    }
  }

  Future<void> _scrapAll(BuildContext context, AppDatabase db) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Scrap all entries?',
      message:
          'This permanently removes every Old Silver entry and resets the running total to zero. '
          'This can\'t be undone.',
      confirmLabel: 'Scrap All',
    );
    if (confirmed) {
      await db.scrapAllOldSilver();
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Silver'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _addEntry(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Entry'),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () => _scrapAll(context, db),
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.statusScrapped),
            label: const Text(
              'Scrap All',
              style: TextStyle(color: AppColors.statusScrapped, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<List<OldSilverEntry>>(
        stream: db.watchOldSilverEntries(),
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <OldSilverEntry>[];

          return Column(
            children: [
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          'No entries yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final theme = Theme.of(context);

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${entry.weightGrams}g',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(color: AppColors.gold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      DateFormat('dd MMM yyyy').format(entry.entryDate),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      entry.note?.trim().isNotEmpty == true
                                          ? entry.note!
                                          : '—',
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    color: AppColors.gold,
                                    onPressed: () => _editEntry(context, entry),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18),
                                    color: AppColors.statusScrapped,
                                    onPressed: () => _deleteEntry(context, db, entry),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  border: Border(top: BorderSide(color: AppColors.borderSubtle)),
                ),
                child: StreamBuilder<double>(
                  stream: db.watchOldSilverTotalWeight(),
                  builder: (context, totalSnapshot) {
                    final total = totalSnapshot.data ?? 0;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Weight', style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          '${total.toStringAsFixed(2)}g',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}