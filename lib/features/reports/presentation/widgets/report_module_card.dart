import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// One section within a module card (e.g. "Available", "Pending").
/// [rows] are pre-built row widgets — the card itself doesn't know
/// about Ornament vs Box column layouts, keeping it fully generic.
class ReportSection {
  const ReportSection({
    required this.label,
    required this.weightGrams,
    required this.rows,
  });

  final String label;
  final double weightGrams;
  final List<Widget> rows;
}

/// A collapsible card for one module (Gold, Silver, Silver+, Old
/// Silver) within a report period. Collapsed: title + one-line
/// snapshot ("Available: 12.40g · Pending: 3.20g · ..."). Expanded:
/// each section's label/weight followed by its itemized rows (or a
/// muted "No entries" line if empty).
class ReportModuleCard extends StatefulWidget {
  const ReportModuleCard({
    super.key,
    required this.title,
    required this.accentColor,
    required this.sections,
    this.initiallyExpanded = false,
  });

  final String title;
  final Color accentColor;
  final List<ReportSection> sections;
  final bool initiallyExpanded;

  @override
  State<ReportModuleCard> createState() => _ReportModuleCardState();
}

class _ReportModuleCardState extends State<ReportModuleCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = widget.sections
        .map((s) => '${s.label}: ${s.weightGrams.toStringAsFixed(2)}g')
        .join(' · ');

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.circle, color: widget.accentColor, size: 14),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          snapshot,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.gold,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final section in widget.sections) ...[
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(section.label, style: theme.textTheme.labelLarge),
                        Text(
                          '${section.weightGrams.toStringAsFixed(2)}g',
                          style: theme.textTheme.labelLarge?.copyWith(color: AppColors.gold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (section.rows.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('No entries', style: theme.textTheme.bodyMedium),
                      )
                    else
                      ...section.rows,
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
