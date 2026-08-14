import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/widgets/group_toggle.dart';

// Reuses the same status set as the ornament list tabs. null = All.
const List<OrnamentStatus?> _statusFilters = [
  null,
  OrnamentStatus.available,
  OrnamentStatus.sold,
  OrnamentStatus.pending,
  OrnamentStatus.scrapped,
];

String _statusFilterLabel(OrnamentStatus? status) {
  if (status == null) return 'All';
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

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key, this.initialGroupName = 'Gold'});

  final String initialGroupName;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late final AppDatabase _db = context.read<AppDatabase>();
  late String _selectedGroupName = widget.initialGroupName;
  OrnamentStatus? _selectedStatus; // null = All

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: GroupToggle(
              names: const ['Gold', 'Silver'],
              selected: _selectedGroupName,
              onSelect: (name) => setState(() => _selectedGroupName = name),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: _statusFilters.map((status) {
                  final isSelected = status == _selectedStatus;
                  return ChoiceChip(
                    label: Text(_statusFilterLabel(status)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStatus = status),
                    selectedColor: AppColors.gold.withOpacity(0.16),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.gold : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.gold : AppColors.borderSubtle,
                    ),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<ItemGroup>(
              future: _db.itemGroupByName(_selectedGroupName),
              builder: (context, groupSnapshot) {
                if (!groupSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.gold));
                }
                final groupId = groupSnapshot.data!.id;

                return StreamBuilder<List<TypeSummaryRow>>(
                  stream: _db.watchTypeSummary(groupId: groupId, status: _selectedStatus),
                  builder: (context, snapshot) {
                    final rows = snapshot.data ?? const <TypeSummaryRow>[];

                    if (rows.isEmpty) {
                      return Center(
                        child: Text(
                          'No ornaments to summarize here yet.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }

                    final totalCount = rows.fold<int>(0, (sum, r) => sum + r.count);
                    final totalWeight = rows.fold<double>(0, (sum, r) => sum + r.totalWeight);

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('TYPE')),
                                DataColumn(label: Text('COUNT'), numeric: true),
                                DataColumn(label: Text('WEIGHT (g)'), numeric: true),
                              ],
                              rows: [
                                ...rows.map(
                                  (row) => DataRow(
                                    cells: [
                                      DataCell(Text(row.typeName)),
                                      DataCell(Text('${row.count}')),
                                      DataCell(Text(row.totalWeight.toStringAsFixed(2))),
                                    ],
                                  ),
                                ),
                                DataRow(
                                  color: WidgetStateProperty.all(AppColors.surfaceMuted),
                                  cells: [
                                    DataCell(Text(
                                      'TOTAL',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w700),
                                    )),
                                    DataCell(Text(
                                      '$totalCount',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(fontWeight: FontWeight.w700),
                                    )),
                                    DataCell(Text(
                                      totalWeight.toStringAsFixed(2),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.gold,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
