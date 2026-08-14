import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Stores small app settings (currently just the chosen DB path) in a
/// JSON file under the platform's application-support directory. This
/// directory is independent of wherever the user chose to put the
/// actual .sqlite file, so it survives the DB being moved.
class SettingsService {
  static const _fileName = 'jewelstock_settings.json';

  Future<File> _settingsFile() async {
    final dir = await getApplicationSupportDirectory();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return File(p.join(dir.path, _fileName));
  }

  Future<Map<String, dynamic>> _readAll() async {
    final file = await _settingsFile();
    if (!file.existsSync()) return {};
    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) return {};
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      // Corrupt/empty settings file — treat as fresh start rather than crash.
      return {};
    }
  }

  Future<void> _writeAll(Map<String, dynamic> data) async {
    final file = await _settingsFile();
    await file.writeAsString(jsonEncode(data));
  }

  Future<String?> getDbPath() async {
    final data = await _readAll();
    return data['db_path'] as String?;
  }

  Future<void> setDbPath(String path) async {
    final data = await _readAll();
    data['db_path'] = path;
    await _writeAll(data);
  }
}
