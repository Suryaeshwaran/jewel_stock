import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../widgets/report_module_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: 'Daily'), Tab(text: 'Monthly'), Tab(text: 'Yearly')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _DailyReportTab(),
                _MonthlyReportTab(),
                _YearlyReportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Date range helpers ----------------

(DateTime, DateTime) _dayRange(DateTime day) {
  final start = DateTime(day.year, day.month, day.day);
  return (start, start.add(const Duration(days: 1)));
}

(DateTime, DateTime) _monthRange(DateTime anchor) {
  final start = DateTime(anchor.year, anchor.month, 1);
  final end = DateTime(anchor.year, anchor.month + 1, 1);
  return (start, end);
}

(DateTime, DateTime) _yearRange(int year) {
  return (DateTime(year, 1, 1), DateTime(year + 1, 1, 1));
}

// ---------------- Daily tab ----------------

class _DailyReportTab extends StatefulWidget {
  const _DailyReportTab();

  @override
  State<_DailyReportTab> createState() => _DailyReportTabState();
}

class _DailyReportTabState extends State<_DailyReportTab> {
  DateTime _selectedDay = DateTime.now();

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDay = picked);
  }

  @override
  Widget build(BuildContext context) {
    final (start, end) = _dayRange(_selectedDay);
    return Column(
      children: [
        _PeriodPicker(
          label: DateFormat('dd MMM yyyy').format(_selectedDay),
          onTap: _pickDay,
        ),
        Expanded(
          child: _ReportBody(start: start, end: end, showDate: false, groupByMonth: false),
        ),
      ],
    );
  }
}

// ---------------- Monthly tab ----------------

class _MonthlyReportTab extends StatefulWidget {
  const _MonthlyReportTab();

  @override
  State<_MonthlyReportTab> createState() => _MonthlyReportTabState();
}

class _MonthlyReportTabState extends State<_MonthlyReportTab> {
  DateTime _selectedMonth = DateTime.now();

  Future<void> _pickMonth() async {
    // No built-in month picker in Flutter — the day picked is
    // discarded, only year+month are used.
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pick any day in the month',
    );
    if (picked != null) setState(() => _selectedMonth = picked);
  }

  @override
  Widget build(BuildContext context) {
    final (start, end) = _monthRange(_selectedMonth);
    return Column(
      children: [
        _PeriodPicker(
          label: DateFormat('MMMM yyyy').format(_selectedMonth),
          onTap: _pickMonth,
        ),
        Expanded(
          child: _ReportBody(start: start, end: end, showDate: true, groupByMonth: false),
        ),
      ],
    );
  }
}

// ---------------- Yearly tab ----------------

class _YearlyReportTab extends StatefulWidget {
  const _YearlyReportTab();

  @override
  State<_YearlyReportTab> createState() => _YearlyReportTabState();
}

class _YearlyReportTabState extends State<_YearlyReportTab> {
  late int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(6, (i) => currentYear - i);
    final (start, end) = _yearRange(_selectedYear);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: DropdownButton<int>(
                value: _selectedYear,
                underline: const SizedBox.shrink(),
                items: years
                    .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                    .toList(),
                onChanged: (y) {
                  if (y != null) setState(() => _selectedYear = y);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: _ReportBody(start: start, end: end, showDate: true, groupByMonth: true),
        ),
      ],
    );
  }
}

// ---------------- Shared period-picker pill ----------------

class _PeriodPicker extends StatelessWidget {
  const _PeriodPicker({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(width: 10),
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.gold),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Report body: fetches + renders everything ----------------

class _ReportData {
  _ReportData({
    required this.goldAvailable,
    required this.goldPending,
    required this.goldSold,
    required this.goldScrapped,
    required this.silverAvailable,
    required this.silverPending,
    required this.silverSold,
    required this.silverScrapped,
    required this.boxAvailable,
    required this.boxPending,
    required this.boxSold,
    required this.oldSilver,
  });

  final List<ReportOrnamentRow> goldAvailable, goldPending, goldSold, goldScrapped;
  final List<ReportOrnamentRow> silverAvailable, silverPending, silverSold, silverScrapped;
  final List<ReportBoxRow> boxAvailable, boxPending, boxSold;
  final List<ReportOldSilverRow> oldSilver;

  static double _sum(List<ReportOrnamentRow> l) => l.fold(0, (s, r) => s + r.weightGrams);
  static double _sumBox(List<ReportBoxRow> l) => l.fold(0, (s, r) => s + r.weightGrams);
  static double _sumOldSilver(List<ReportOldSilverRow> l) => l.fold(0, (s, r) => s + r.weightGrams);
}

class _ReportBody extends StatefulWidget {
  const _ReportBody({
    required this.start,
    required this.end,
    required this.showDate,
    required this.groupByMonth,
  });

  final DateTime start;
  final DateTime end;
  final bool showDate;
  final bool groupByMonth;

  @override
  State<_ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<_ReportBody> {
  late Future<_ReportData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant _ReportBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start || oldWidget.end != widget.end) {
      setState(() {
        _future = _load();
      });
    }
  }

  Future<_ReportData> _load() async {
    final db = context.read<AppDatabase>();
    final goldGroup = await db.itemGroupByName('Gold');
    final silverGroup = await db.itemGroupByName('Silver');
    final s = widget.start;
    final e = widget.end;

    final results = await Future.wait([
      db.reportOrnamentsAvailable(groupId: goldGroup.id, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: goldGroup.id, status: OrnamentStatus.pending, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: goldGroup.id, status: OrnamentStatus.sold, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: goldGroup.id, status: OrnamentStatus.scrapped, start: s, end: e),
      db.reportOrnamentsAvailable(groupId: silverGroup.id, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: silverGroup.id, status: OrnamentStatus.pending, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: silverGroup.id, status: OrnamentStatus.sold, start: s, end: e),
      db.reportOrnamentsByStatus(groupId: silverGroup.id, status: OrnamentStatus.scrapped, start: s, end: e),
    ]);

    final boxResults = await Future.wait([
      db.reportBoxesAvailable(start: s, end: e),
      db.reportAllocations(status: AllocationStatus.pending, start: s, end: e),
      db.reportAllocations(status: AllocationStatus.sold, start: s, end: e),
    ]);

    final oldSilver = await db.reportOldSilverEntries(start: s, end: e);

    return _ReportData(
      goldAvailable: results[0] as List<ReportOrnamentRow>,
      goldPending: results[1] as List<ReportOrnamentRow>,
      goldSold: results[2] as List<ReportOrnamentRow>,
      goldScrapped: results[3] as List<ReportOrnamentRow>,
      silverAvailable: results[4] as List<ReportOrnamentRow>,
      silverPending: results[5] as List<ReportOrnamentRow>,
      silverSold: results[6] as List<ReportOrnamentRow>,
      silverScrapped: results[7] as List<ReportOrnamentRow>,
      boxAvailable: boxResults[0] as List<ReportBoxRow>,
      boxPending: boxResults[1] as List<ReportBoxRow>,
      boxSold: boxResults[2] as List<ReportBoxRow>,
      oldSilver: oldSilver,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ReportData>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.gold));
        }
        final data = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            ReportModuleCard(
              title: 'Gold',
              accentColor: AppColors.gold,
              sections: [
                ReportSection(
                  label: 'Available',
                  weightGrams: _ReportData._sum(data.goldAvailable),
                  rows: _ornamentRows(data.goldAvailable, showCustomer: false),
                ),
                ReportSection(
                  label: 'Pending',
                  weightGrams: _ReportData._sum(data.goldPending),
                  rows: _ornamentRows(data.goldPending, showCustomer: true),
                ),
                ReportSection(
                  label: 'Sold',
                  weightGrams: _ReportData._sum(data.goldSold),
                  rows: _ornamentRows(data.goldSold, showCustomer: false),
                ),
                ReportSection(
                  label: 'Scrapped',
                  weightGrams: _ReportData._sum(data.goldScrapped),
                  rows: _ornamentRows(data.goldScrapped, showCustomer: false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportModuleCard(
              title: 'Silver',
              accentColor: AppColors.silver,
              sections: [
                ReportSection(
                  label: 'Available',
                  weightGrams: _ReportData._sum(data.silverAvailable),
                  rows: _ornamentRows(data.silverAvailable, showCustomer: false),
                ),
                ReportSection(
                  label: 'Pending',
                  weightGrams: _ReportData._sum(data.silverPending),
                  rows: _ornamentRows(data.silverPending, showCustomer: true),
                ),
                ReportSection(
                  label: 'Sold',
                  weightGrams: _ReportData._sum(data.silverSold),
                  rows: _ornamentRows(data.silverSold, showCustomer: false),
                ),
                ReportSection(
                  label: 'Scrapped',
                  weightGrams: _ReportData._sum(data.silverScrapped),
                  rows: _ornamentRows(data.silverScrapped, showCustomer: false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportModuleCard(
              title: 'Silver+ (Boxes)',
              accentColor: const Color(0xFFB76E79),
              sections: [
                ReportSection(
                  label: 'Available',
                  weightGrams: _ReportData._sumBox(data.boxAvailable),
                  rows: _boxRows(data.boxAvailable, showCustomer: false),
                ),
                ReportSection(
                  label: 'Pending',
                  weightGrams: _ReportData._sumBox(data.boxPending),
                  rows: _boxRows(data.boxPending, showCustomer: true),
                ),
                ReportSection(
                  label: 'Sold',
                  weightGrams: _ReportData._sumBox(data.boxSold),
                  rows: _boxRows(data.boxSold, showCustomer: false),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportModuleCard(
              title: 'Old Silver',
              accentColor: const Color(0xFF8C7853),
              sections: [
                ReportSection(
                  label: 'Scrap',
                  weightGrams: _ReportData._sumOldSilver(data.oldSilver),
                  rows: _oldSilverRows(data.oldSilver),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ---- Row builders ----

  List<Widget> _ornamentRows(List<ReportOrnamentRow> items, {required bool showCustomer}) {
    return _withMonthGrouping<ReportOrnamentRow>(
      items,
      (r) => r.date,
      (r) => _dataRow([
        _cell(r.code, flex: 3, accent: true),
        _cell(r.typeName, flex: 2),
        if (widget.showDate) _cell(DateFormat('dd MMM').format(r.date), flex: 2),
        if (showCustomer)
          _cell(r.customerName?.trim().isNotEmpty == true ? r.customerName! : '—', flex: 2),
        _cell('${r.weightGrams.toStringAsFixed(2)}g', flex: 2, alignRight: true),
      ]),
    );
  }

  List<Widget> _boxRows(List<ReportBoxRow> items, {required bool showCustomer}) {
    return _withMonthGrouping<ReportBoxRow>(
      items,
      (r) => r.date,
      (r) => _dataRow([
        _cell(r.boxCode, flex: 3, accent: true),
        _cell('${r.count} pcs', flex: 2),
        if (widget.showDate) _cell(DateFormat('dd MMM').format(r.date), flex: 2),
        if (showCustomer)
          _cell(r.customerName?.trim().isNotEmpty == true ? r.customerName! : '—', flex: 2),
        _cell('${r.weightGrams.toStringAsFixed(2)}g', flex: 2, alignRight: true),
      ]),
    );
  }

  List<Widget> _oldSilverRows(List<ReportOldSilverRow> items) {
    return _withMonthGrouping<ReportOldSilverRow>(
      items,
      (r) => r.date,
      (r) => _dataRow([
        if (widget.showDate) _cell(DateFormat('dd MMM').format(r.date), flex: 2),
        _cell('${r.weightGrams.toStringAsFixed(2)}g', flex: 2, accent: true),
        _cell(r.note?.trim().isNotEmpty == true ? r.note! : '—', flex: 4),
      ]),
    );
  }

  /// If [widget.groupByMonth] is set (Yearly tab), inserts a bold
  /// "August 2026" header before each month's rows. Items are assumed
  /// already sorted ascending by date (the DB queries order this way).
  List<Widget> _withMonthGrouping<T>(
    List<T> items,
    DateTime Function(T) dateOf,
    Widget Function(T) rowBuilder,
  ) {
    if (!widget.groupByMonth) {
      return items.map(rowBuilder).toList();
    }

    final widgets = <Widget>[];
    String? currentMonthKey;
    for (final item in items) {
      final date = dateOf(item);
      final monthKey = DateFormat('MMMM yyyy').format(date);
      if (monthKey != currentMonthKey) {
        currentMonthKey = monthKey;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              monthKey,
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gold),
            ),
          ),
        );
      }
      widgets.add(rowBuilder(item));
    }
    return widgets;
  }

  Widget _dataRow(List<Widget> cells) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: cells),
    );
  }

  Widget _cell(String text, {required int flex, bool accent = false, bool alignRight = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: 13,
          color: accent ? AppColors.gold : AppColors.textSecondary,
          fontWeight: accent ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}