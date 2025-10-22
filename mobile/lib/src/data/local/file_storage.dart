import 'dart:convert';
import 'dart:io';

/// File storage without platform plugins (no CocoaPods needed on iOS).
/// Uses systemTemp as a cross-platform writable directory.
class FileStorage {
  final String fileName;

  FileStorage(this.fileName);

  Future<File> _getFile() async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$fileName');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }
    return file;
  }

  Future<List<dynamic>> readJsonList() async {
    final file = await _getFile();
    final content = await file.readAsString();
    final data = jsonDecode(content);
    if (data is List) return data;
    return [];
  }

  Future<void> writeJsonList(List<Map<String, dynamic>> list) async {
    final file = await _getFile();
    final content = jsonEncode(list);
    await file.writeAsString(content);
  }
}
