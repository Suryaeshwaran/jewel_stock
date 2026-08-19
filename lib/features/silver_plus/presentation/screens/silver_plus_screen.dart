import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../item_type/presentation/widgets/item_type_dialog.dart' show showConfirmDialog;
import '../widgets/add_box_dialog.dart';
import '../widgets/refill_dialog.dart';
import '../widgets/sale_dialog.dart';

class SilverPlusScreen extends StatefulWidget {
  const SilverPlusScreen({super.key});

  @override
  State<SilverPlusScreen> createState() => _SilverPlusScreenState();
}

class _SilverPlusScreenState extends State<SilverPlusScreen>
    with SingleTickerProviderStateMixin {
  late final AppDatabase _db = context.read<AppDatabase>();
  late final TabController _tabController = TabController(length: 2, vsync: this);

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

  Future<void> _sell(SilverPlusBox box) async {
    final sold = await showDialog<bool>(context: context, builder: (_) => SaleDialog(box: box));
    if (sold == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded')),
      );
    }
  }

  Future<void> _refill(SilverPlusBox box) async {
    await showDialog<bool>(context: context, builder: (_) => RefillDialog(box: box));
  }

  Future<void> _editBox(SilverPlusBox box) async {
    await showDialog<bool>(context: context, builder: (_) => BoxDialog(existing: box));
  }

  Future<void> _deleteBox(SilverPlusBox box) async {
    final salesCount = await _db.countSalesOfBox(box.id);
    if (!mounted) return;

    if (salesCount > 0) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Can\'t delete this box'),
          content: Text(
            'This box has $salesCount sale ${salesCount == 1 ? 'record' : 'records'}. '
            'It can\'t be deleted since that would break the sales history.',
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

  Future<void> _editSale(SilverPlusSaleRow sale) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => SaleDialog(existingSale: sale),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale updated')),
      );
    }
  }

  Future<void> _deleteSale(SilverPlusSaleRow sale) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this sale?',
      message: '${sale.countSold} pcs · ${sale.weightSoldGrams}g from ${sale.boxCode} on '
          '${DateFormat('dd MMM yyyy').format(sale.saleDate)}. '
          'The box\'s stock will NOT be restored. This can\'t be undone.',
    );
    if (confirmed) {
      await _db.deleteSale(sale.id);
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
            tabs: const [Tab(text: 'Available'), Tab(text: 'Sold')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AvailableTab(
                  db: _db,
                  search: _search,
                  onSell: _sell,
                  onRefill: _refill,
                  onEdit: _editBox,
                  onDelete: _deleteBox,
                ),
                _SoldTab(
                  db: _db,
                  search: _search,
                  onEdit: _editSale,
                  onDelete: _deleteSale,
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
    required this.onSell,
    required this.onRefill,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase db;
  final String search;
  final ValueChanged<SilverPlusBox> onSell;
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
                onTap: () => onSell(box),
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

class _SoldTab extends StatelessWidget {
  const _SoldTab({
    required this.db,
    required this.search,
    required this.onEdit,
    required this.onDelete,
  });

  final AppDatabase db;
  final String search;
  final ValueChanged<SilverPlusSaleRow> onEdit;
  final ValueChanged<SilverPlusSaleRow> onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SilverPlusSaleRow>>(
      stream: db.watchSales(searchTerm: search),
      builder: (context, snapshot) {
        final sales = snapshot.data ?? const <SilverPlusSaleRow>[];

        if (sales.isEmpty) {
          return Center(
            child: Text('No sales recorded yet.', style: Theme.of(context).textTheme.bodyMedium),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: sales.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final sale = sales[index];
            final theme = Theme.of(context);

            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        sale.boxCode,
                        style: theme.textTheme.titleMedium?.copyWith(color: AppColors.gold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('${sale.countSold} pcs', style: theme.textTheme.bodyMedium),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        DateFormat('dd MMM yyyy').format(sale.saleDate),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${sale.weightSoldGrams}g',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: AppColors.gold,
                      tooltip: 'Edit',
                      onPressed: () => onEdit(sale),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: AppColors.statusScrapped,
                      tooltip: 'Delete',
                      onPressed: () => onDelete(sale),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}