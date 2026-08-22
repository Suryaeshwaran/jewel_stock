import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' show Value;

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/text_formatters.dart';

/// Handles both Add and Edit. Pass [existing] to edit an ornament in
/// place; leave it null to create a new one (status defaults to
/// available and is not shown here — status changes happen from the
/// ornament list/detail screen instead).
class AddOrnamentScreen extends StatefulWidget {
  const AddOrnamentScreen({super.key, this.existing, this.initialGroupName});

  final Ornament? existing;

  /// Preselects a group when adding fresh from a Gold/Silver list view.
  final String? initialGroupName;

  bool get isEditing => existing != null;

  @override
  State<AddOrnamentScreen> createState() => _AddOrnamentScreenState();
}

class _AddOrnamentScreenState extends State<AddOrnamentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase _db = context.read<AppDatabase>();

  final _codeController = TextEditingController();
  final _weightController = TextEditingController();

  ItemGroup? _selectedGroup;
  ItemType? _selectedType;
  late DateTime _entryDate;

  bool _saving = false;
  String? _codeError;

  @override
  void initState() {
    super.initState();
    _entryDate = widget.existing?.entryDate ?? DateTime.now();
    if (widget.existing != null) {
      _codeController.text = widget.existing!.ornamentCode;
      _weightController.text = _trimZeros(widget.existing!.weightGrams);
    }
  }

  String _trimZeros(double value) {
    var s = value.toStringAsFixed(3);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
    }
  }

  Future<void> _save() async {
    if (_selectedGroup == null || _selectedType == null) return;
    if (!_formKey.currentState!.validate()) return;

    final code = _codeController.text.trim();
    setState(() {
      _saving = true;
      _codeError = null;
    });

    final taken = await _db.isOrnamentCodeTaken(
      _selectedGroup!.id,
      code,
      excludingId: widget.existing?.id,
    );
    if (taken) {
      setState(() {
        _saving = false;
        _codeError = 'This ID is already used in ${_selectedGroup!.name}';
      });
      return;
    }

    final weight = double.parse(_weightController.text);

    if (widget.isEditing) {
      await _db.updateOrnament(
        widget.existing!.id,
        OrnamentsCompanion(
          ornamentCode: Value(code),
          itemGroupId: Value(_selectedGroup!.id),
          itemTypeId: Value(_selectedType!.id),
          weightGrams: Value(weight),
          entryDate: Value(_entryDate),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.addOrnament(
        OrnamentsCompanion.insert(
          ornamentCode: code,
          itemGroupId: _selectedGroup!.id,
          itemTypeId: _selectedType!.id,
          weightGrams: weight,
          entryDate: _entryDate,
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Ornament' : 'Add Ornament')),
      body: LayoutBuilder(
        builder: (context, outerConstraints) {
          return StreamBuilder<List<ItemGroup>>(
            stream: _db.watchItemGroups(),
            builder: (context, groupSnapshot) {
              final groups = groupSnapshot.data ?? const <ItemGroup>[];
              if (groups.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.gold));
              }

              // Resolve initial selection once groups are available.
              if (_selectedGroup == null) {
                final wantName = widget.existing != null
                    ? groups.firstWhere((g) => g.id == widget.existing!.itemGroupId).name
                    : (widget.initialGroupName ?? groups.first.name);
                _selectedGroup =
                    groups.firstWhere((g) => g.name == wantName, orElse: () => groups.first);
              }

              // Desktop-only screen: form sits at 20% of the window width,
              // centered on the page.
              final formWidth = outerConstraints.maxWidth * 0.4;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: outerConstraints.maxHeight - 40, // account for padding
                    ),
                    child: Center(
                      child: SizedBox(
                        width: formWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                Text('Item Group', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                DropdownButtonFormField<ItemGroup>(
                  value: _selectedGroup,
                  items: groups
                      .map((g) => DropdownMenuItem(value: g, child: Text(g.name)))
                      .toList(),
                  onChanged: (group) {
                    setState(() {
                      _selectedGroup = group;
                      _selectedType = null; // reset type when group changes
                    });
                  },
                ),
                const SizedBox(height: 20),

                Text('Item Type', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                StreamBuilder<List<ItemType>>(
                  stream: _db.watchItemTypes(_selectedGroup!.id),
                  builder: (context, typeSnapshot) {
                    final types = typeSnapshot.data ?? const <ItemType>[];

                    if (_selectedType == null && widget.existing != null) {
                      final match = types.where((t) => t.id == widget.existing!.itemTypeId);
                      if (match.isNotEmpty) {
                        // Mutating _selectedType here alone doesn't rebuild
                        // the rest of the screen (e.g. the Save button
                        // below, which reads _selectedType too) — this
                        // StreamBuilder only rebuilds itself. Schedule a
                        // proper setState right after this frame instead.
                        final resolved = match.first;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && _selectedType == null) {
                            setState(() => _selectedType = resolved);
                          }
                        });
                      }
                    }

                    if (types.isEmpty) {
                      return Text(
                        'No item types yet for ${_selectedGroup!.name}. Add one from Item Types first.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }

                    return DropdownButtonFormField<ItemType>(
                      value: _selectedType,
                      hint: const Text('Select a type'),
                      items: types
                          .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                          .toList(),
                      validator: (value) => value == null ? 'Select an item type' : null,
                      onChanged: (type) => setState(() => _selectedType = type),
                    );
                  },
                ),
                const SizedBox(height: 20),

                Text('Ornament ID', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _codeController,
                  inputFormatters: [AlphanumericUpperCaseFormatter()],
                  decoration: InputDecoration(
                    hintText: 'e.g. GN1042',
                    errorText: _codeError,
                  ),
                  onChanged: (_) {
                    if (_codeError != null) setState(() => _codeError = null);
                  },
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Enter an ornament ID' : null,
                ),
                const SizedBox(height: 20),

                Text('Weight (grams)', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [DecimalTextFormatter()],
                  decoration: const InputDecoration(hintText: 'e.g. 18.4'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Enter the weight';
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) return 'Enter a valid weight';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

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
                        Text(
                          DateFormat('dd MMM yyyy').format(_entryDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.gold),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_saving || _selectedType == null) ? null : _save,
                    child: Text(_saving
                        ? 'Saving…'
                        : (widget.isEditing ? 'Save Changes' : 'Add Ornament')),
                  ),
                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}