import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../widgets/item_type_dialog.dart';

class ItemTypeManagementScreen extends StatefulWidget {
  const ItemTypeManagementScreen({super.key});

  @override
  State<ItemTypeManagementScreen> createState() => _ItemTypeManagementScreenState();
}

class _ItemTypeManagementScreenState extends State<ItemTypeManagementScreen> {
  static const _groupNames = ['Gold', 'Silver'];
  String _selectedGroup = 'Gold';

  late final AppDatabase _db = context.read<AppDatabase>();

  // Resolved once at startup — both groups are needed simultaneously so the
  // toggle can show live counts for Gold and Silver at the same time.
  late final Future<Map<String, ItemGroup>> _groupsFuture = _loadGroups();

  Future<Map<String, ItemGroup>> _loadGroups() async {
    final entries = await Future.wait(
      _groupNames.map((name) async => MapEntry(name, await _db.itemGroupByName(name))),
    );
    return Map.fromEntries(entries);
  }

  void _selectGroup(String name) {
    if (name == _selectedGroup) return;
    setState(() => _selectedGroup = name);
  }

  Future<void> _addType(int groupId, Set<String> existingLower) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => ItemTypeDialog(
        groupLabel: _selectedGroup,
        existingNamesLower: existingLower,
      ),
    );
    if (name == null) return;
    await _db.addItemType(groupId, name);
  }

  Future<void> _editType(ItemType type, Set<String> existingLower) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => ItemTypeDialog(
        groupLabel: _selectedGroup,
        existingNamesLower: existingLower,
        initialName: type.name,
      ),
    );
    if (name == null || name == type.name) return;
    await _db.renameItemType(type.id, name);
  }

  Future<void> _deleteType(ItemType type) async {
    final count = await _db.countOrnamentsOfType(type.id);
    if (!mounted) return;

    if (count > 0) {
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Can\'t delete this type'),
          content: Text(
            '$count ${count == 1 ? 'ornament uses' : 'ornaments use'} "${type.name}". '
            'Reassign or remove those ornaments first.',
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
      title: 'Delete "${type.name}"?',
      message: 'This can\'t be undone.',
    );
    if (confirmed) {
      await _db.deleteItemType(type.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Types')),
      body: FutureBuilder<Map<String, ItemGroup>>(
        future: _groupsFuture,
        builder: (context, groupsSnapshot) {
          if (!groupsSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }
          final groups = groupsSnapshot.data!;
          final groupId = groups[_selectedGroup]!.id;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: _GroupToggle(
                  names: _groupNames,
                  selected: _selectedGroup,
                  onSelect: _selectGroup,
                  groups: groups,
                  db: _db,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<ItemType>>(
                  stream: _db.watchItemTypes(groupId),
                  builder: (context, snapshot) {
                    final types = snapshot.data ?? const <ItemType>[];
                    final existingLower = types.map((t) => t.name.toLowerCase()).toSet();

                    return Column(
                      children: [
                        Expanded(
                          child: types.isEmpty
                              ? Center(
                                  child: Text(
                                    'No item types yet for $_selectedGroup.',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Fixed-width columns: pick how many columns fit
                                    // at a target tile width, then let the grid
                                    // stretch each column evenly to fill the row.
                                    const spacing = 12.0;
                                    const targetTileWidth = 210.0;
                                    const horizontalPadding = 40.0; // 20 left + 20 right

                                    final available = constraints.maxWidth - horizontalPadding;
                                    var crossAxisCount =
                                        ((available + spacing) / (targetTileWidth + spacing))
                                            .floor();
                                    if (crossAxisCount < 2) crossAxisCount = 2;

                                    return GridView.builder(
                                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                      itemCount: types.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: spacing,
                                        crossAxisSpacing: spacing,
                                        mainAxisExtent: 60,
                                      ),
                                      itemBuilder: (context, index) {
                                        final type = types[index];
                                        return _ItemTypeTile(
                                          type: type,
                                          onEdit: () => _editType(
                                            type,
                                            existingLower.difference({type.name.toLowerCase()}),
                                          ),
                                          onDelete: () => _deleteType(type),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _addType(groupId, existingLower),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item Type'),
                            ),
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

/// A single item-type tile: one row, name on the left (ellipsized if it
/// doesn't fit) with Edit + Delete icons pinned to the right. Tiles are
/// arranged in an N-column wrap grid rather than one-per-line.
class _ItemTypeTile extends StatelessWidget {
  const _ItemTypeTile({
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  final ItemType type;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                type.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.gold,
              visualDensity: VisualDensity.compact,
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            const SizedBox(width: 2),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.statusScrapped,
              visualDensity: VisualDensity.compact,
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupToggle extends StatelessWidget {
  const _GroupToggle({
    required this.names,
    required this.selected,
    required this.onSelect,
    required this.groups,
    required this.db,
  });

  final List<String> names;
  final String selected;
  final ValueChanged<String> onSelect;
  final Map<String, ItemGroup> groups;
  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: names.map((name) {
          final isSelected = name == selected;
          final groupId = groups[name]!.id;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: AppColors.borderSubtle) : null,
                ),
                alignment: Alignment.center,
                child: StreamBuilder<int>(
                  stream: db.watchItemTypeCount(groupId),
                  builder: (context, snapshot) {
                    final count = snapshot.data;
                    final label = count == null ? name : '$name ($count)';
                    return Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.gold : AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}