import 'package:flutter/material.dart';
// import '../../../../app/theme/app_colors.dart';
import '../../../item_type/presentation/screens/item_type_management_screen.dart';
import '../../../ornament/presentation/screens/ornament_list_screen.dart';
import '../../../summary/presentation/screens/summary_screen.dart';

/// Landing screen — quick links into Gold, Silver, Summary, Item Type
/// management, and Settings.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('JewelStock'), centerTitle: true),
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
              final manageTileWidth = (constraints.maxWidth * 0.15).clamp(140.0, 220.0);

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
                        SizedBox(
                          width: manageTileWidth,
                          child: _ManageTile(
                            emoji: '📖',
                            label: 'Summary',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SummaryScreen()),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: manageTileWidth,
                          child: _ManageTile(
                            emoji: '🧩',
                            label: 'Item Types',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ItemTypeManagementScreen(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: manageTileWidth,
                          child: _ManageTile(
                            emoji: '⚙️',
                            label: 'Settings',
                            onTap: () {},
                          ),
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
              Text(label, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

/// Manage tile with Emoji on top and Text on the bottom.
class _ManageTile extends StatelessWidget {
  const _ManageTile({required this.emoji, required this.label, required this.onTap});

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                label,
                //style: Theme.of(context).textTheme.bodyLarge,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}