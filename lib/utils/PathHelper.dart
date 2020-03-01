import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<String> getExternalStorageDir() async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }
}
