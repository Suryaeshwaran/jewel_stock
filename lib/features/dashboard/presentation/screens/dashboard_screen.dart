import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../item_type/presentation/screens/item_type_management_screen.dart';
import '../../../ornament/presentation/screens/ornament_list_screen.dart';
import '../../../old_silver/presentation/screens/old_silver_screen.dart';
import '../../../reports/presentation/screens/reports_screen.dart';
import '../../../silver_plus/presentation/screens/silver_plus_screen.dart';
import '../../../summary/presentation/screens/summary_screen.dart';

/// Landing screen — quick links into Gold, Silver, Summary, Item Type
/// management, and Settings.
/// Test 
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Jewel Stock'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 250, 138, 68), width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final groupCardWidth = (constraints.maxWidth * 0.22).clamp(160.0, 260.0);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inventory Groups', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: groupCardWidth,
                          child: _GroupCard(
                            label: 'Gold',
                            color: const Color(0xFFD2C51A),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const OrnamentListScreen(initialGroupName: 'Gold'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: groupCardWidth,
                          child: _GroupCard(
                            label: 'Silver',
                            color: const Color(0xFF115FA8),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const OrnamentListScreen(initialGroupName: 'Silver'),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: groupCardWidth,
                          child: _GroupCard(
                            label: 'Silver+(Boxes)',
                            color: const Color(0xFFB76E79),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SilverPlusScreen()),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: groupCardWidth,
                          child: _GroupCard(
                            label: 'Old Silver',
                            color: const Color(0xFF8C7853),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const OldSilverScreen()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      color: Color.fromARGB(255, 250, 138, 68),
                      thickness: 1.5,
                    ),
                    const SizedBox(height: 16),
                    Text('Manage', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _ManageTile(
                          icon: Icons.bar_chart_rounded,
                          label: 'Summary',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SummaryScreen()),
                          ),
                        ),
                        _ManageTile(
                          icon: Icons.description_rounded,
                          label: 'Reports',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ReportsScreen()),
                          ),
                        ),
                        _ManageTile(
                          icon: Icons.diamond_rounded,
                          label: 'Item Types',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ItemTypeManagementScreen(),
                            ),
                          ),
                        ),
                        _ManageTile(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Gold/Silver group card — colored dot, no emoji, sized to ~30% width
/// by the caller.
class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.label, required this.color, required this.onTap});

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.circle, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Manage tile — icon and label on the same line, compact height.
class _ManageTile extends StatelessWidget {
  const _ManageTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}