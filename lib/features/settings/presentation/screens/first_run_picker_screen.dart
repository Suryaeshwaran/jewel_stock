import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

/// Shown once, on Windows, when no database path has been saved yet.
class FirstRunPickerScreen extends StatelessWidget {
  const FirstRunPickerScreen({super.key, required this.onChooseFolder, this.isChoosing = false});

  final VoidCallback onChooseFolder;
  final bool isChoosing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.diamond_outlined, size: 56, color: AppColors.gold),
                const SizedBox(height: 24),
                Text('Welcome to JewelStock', style: theme.textTheme.displayMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  'Choose a folder where your inventory database will be created. '
                  'This only needs to be done once — JewelStock will remember it '
                  'on every future launch.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isChoosing ? null : onChooseFolder,
                    icon: const Icon(Icons.folder_open),
                    label: Text(isChoosing ? 'Waiting for selection…' : 'Choose Folder'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
