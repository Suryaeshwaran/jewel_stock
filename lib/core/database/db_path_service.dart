import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../services/settings_service.dart';

/// Resolves where the JewelStock SQLite file should live.
///
/// - Windows: first run asks the user to pick a folder, creates
///   `jewelstock.sqlite` there, and remembers the path in settings.
///   Later runs read the saved path directly — no prompt.
/// - macOS (dev): silently uses the app-support directory, no prompt,
///   since this is sandbox/dev-only and location doesn't matter.
class DbPathService {
  DbPathService(this._settings);

  final SettingsService _settings;
  static const _dbFileName = 'jewelstock.sqlite';

  /// Returns a ready-to-use DB file path, or null if the user still
  /// needs to be prompted (Windows first run, or a saved path that no
  /// longer exists — e.g. drive unplugged).
  Future<String?> resolveExistingPath() async {
    if (Platform.isMacOS) {
      final dir = await getApplicationSupportDirectory();
      return p.join(dir.path, _dbFileName);
    }

    final saved = await _settings.getDbPath();
    if (saved != null && File(saved).existsSync()) {
      return saved;
    }
    return null;
  }

  /// First-run (or re-prompt) flow: user picks a folder, we create a
  /// brand-new `jewelstock.sqlite` there and remember the path.
  Future<String?> pickNewDatabaseFolder() async {
    final folder = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose a folder to store the JewelStock database',
    );
    if (folder == null) return null;

    final dbPath = p.join(folder, _dbFileName);
    await _settings.setDbPath(dbPath);
    return dbPath;
  }

  /// Settings > "Change Database Location". Per spec this always points
  /// to a new/blank location — it does not copy the existing database.
  Future<String?> changeToNewBlankLocation() => pickNewDatabaseFolder();
}
