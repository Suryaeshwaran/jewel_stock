import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../shared/widgets/group_toggle.dart';
import '../../../item_type/presentation/widgets/item_type_dialog.dart';
import '../widgets/status_change_dialog.dart';
import 'add_ornament_screen.dart';

class OrnamentListScreen extends StatefulWidget {
  const OrnamentListScreen({super.key, this.initialGroupName = 'Gold'});

  final String initialGroupName;

  @override
  State<OrnamentListScreen> createState() => _OrnamentListScreenState();
}

// Tabs, in display order. null = All.
const List<OrnamentStatus?> _statusTabs = [
  null,
  OrnamentStatus.available,
  OrnamentStatus.sold,
  OrnamentStatus.pending,
  OrnamentStatus.scrapped,
];

const List<String> _statusTabLabels = ['All', 'Available', 'Sold', 'Pending', 'Scrapped'];

class _OrnamentListScreenState extends State<OrnamentListScreen>
    with SingleTickerProviderStateMixin {
  late final AppDatabase _db = context.read<AppDatabase>();
  late String _selectedGroupName = widget.initialGroupName;
  late final TabController _tabController =
      TabController(length: _statusTabs.length, vsync: this);

  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteOrnament(Ornament ornament) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete "${ornament.ornamentCode}"?',
      message: 'This permanently removes the ornament. This can\'t be undone.',
    );
    if (confirmed) {
      await _db.deleteOrnament(ornament.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ornaments')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.onGold,
        icon: const Icon(Icons.add),
        label: const Text('Add Ornament'),
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => AddOrnamentScreen(initialGroupName: _selectedGroupName),
            ),
          );
          if (added == true && mounted) setState(() {});
        },
      ),
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
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ornament ID',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _statusTabLabels.map((label) => Tab(text: label)).toList(),
          ),
          Expanded(
            child: FutureBuilder<ItemGroup>(
              future: _db.itemGroupByName(_selectedGroupName),
              builder: (context, groupSnapshot) {
                if (!groupSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.gold));
                }
                final groupId = groupSnapshot.data!.id;

                return StreamBuilder<List<ItemType>>(
                  stream: _db.watchItemTypes(groupId),
                  builder: (context, typeSnapshot) {
                    final typeNameById = {
                      for (final t in (typeSnapshot.data ?? const <ItemType>[])) t.id: t.name,
                    };

                    return TabBarView(
                      controller: _tabController,
                      children: _statusTabs.map((status) {
                        return _OrnamentTab(
                          db: _db,
                          groupId: groupId,
                          status: status,
                          search: _search,
                          typeNameById: typeNameById,
                          onDelete: _deleteOrnament,
                          onEdit: (ornament) async {
                            final saved = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => AddOrnamentScreen(existing: ornament),
                              ),
                            );
                            if (saved == true && mounted) setState(() {});
                          },
                        );
                      }).toList(),
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

class _OrnamentTab extends StatelessWidget {
  const _OrnamentTab({
    required this.db,
    required this.groupId,
    required this.status,
    required this.search,
    required this.typeNameById,
    required this.onDelete,
    required this.onEdit,
  });

  final AppDatabase db;
  final int groupId;
  final OrnamentStatus? status;
  final String search;
  final Map<int, String> typeNameById;
  final ValueChanged<Ornament> onDelete;
  final ValueChanged<Ornament> onEdit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ornament>>(
      stream: db.watchOrnaments(groupId: groupId, status: status, searchTerm: search),
      builder: (context, snapshot) {
        final ornaments = snapshot.data ?? const <Ornament>[];

        if (ornaments.isEmpty) {
          return Center(
            child: Text(
              'No ornaments here yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          itemCount: ornaments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final ornament = ornaments[index];
            final typeName = typeNameById[ornament.itemTypeId] ?? '—';

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final changed = await showStatusChangeDialog(context, ornament);
                  if (changed == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Status updated')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          ornament.ornamentCode,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.gold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(typeName, style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${ornament.weightGrams}g',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: AppColors.gold,
                        onPressed: () => onEdit(ornament),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: AppColors.statusScrapped,
                        onPressed: () => onDelete(ornament),
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
