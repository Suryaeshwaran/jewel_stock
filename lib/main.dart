import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'core/database/db_path_service.dart';
import 'core/services/settings_service.dart';
import 'features/settings/presentation/screens/boot_loading_screen.dart';
import 'features/settings/presentation/screens/first_run_picker_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JewelStockBootstrap());
}

/// Resolves the DB path (including the first-run folder picker on
/// Windows) before handing off to the real [JewelStockApp] with a live
/// [AppDatabase] instance wired through Provider.
class JewelStockBootstrap extends StatefulWidget {
  const JewelStockBootstrap({super.key});

  @override
  State<JewelStockBootstrap> createState() => _JewelStockBootstrapState();
}

class _JewelStockBootstrapState extends State<JewelStockBootstrap> {
  final SettingsService _settingsService = SettingsService();
  late final DbPathService _dbPathService = DbPathService(_settingsService);

  String? _dbPath;
  bool _resolving = true;
  bool _choosingFolder = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    final existing = await _dbPathService.resolveExistingPath();
    if (!mounted) return;
    setState(() {
      _dbPath = existing;
      _resolving = false;
    });
  }

  Future<void> _onChooseFolder() async {
    setState(() => _choosingFolder = true);
    final path = await _dbPathService.pickNewDatabaseFolder();
    if (!mounted) return;
    setState(() {
      _dbPath = path;
      _choosingFolder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Theme isn't wired yet at this point (no MaterialApp ancestor), so
    // these two pre-app screens get their own minimal MaterialApp shells.
    if (_resolving) {
      return const MaterialApp(debugShowCheckedModeBanner: false, home: BootLoadingScreen());
    }

    if (_dbPath == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirstRunPickerScreen(
          onChooseFolder: _onChooseFolder,
          isChoosing: _choosingFolder,
        ),
      );
    }

    final database = AppDatabase(_dbPath!);

    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<SettingsService>.value(value: _settingsService),
        Provider<DbPathService>.value(value: _dbPathService),
      ],
      child: const JewelStockApp(),
    );
  }
}
