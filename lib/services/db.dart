import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_model.dart';

class Db {
  AppModel? _model;

  get model async {
    _model ??= await loadModel();
    return _model;
  }

  Future<String> get exportDbFilePath async {
    final directory = await getExternalStorageDirectory();
    return "${directory!.path}/water_me.json";
  }

  Future<String> get exportImageDirectoryPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<String> get exportDbBackupPath async {
    final directory = await getExternalStorageDirectory();
    return "${directory!.path}/water_me.backup.json";
  }

  Future<File> get exportFile async {
    final path = await exportDbFilePath;
    return File(path!);
  }

  Future<File> get exportBackupFile async {
    final path = await exportDbBackupPath;
    return File(path!);
  }

  void saveModel(AppModel model) async {
    final prefs = await SharedPreferences.getInstance();
    print(model);
    prefs.setString('model', json.encode(model.toJson()));
  }

  void save() async {
    if (_model != null) {
      saveModel(_model!);
    }
  }

  Future<AppModel> loadModel() async {
    final prefs = await SharedPreferences.getInstance();
    var m = prefs.getString('model');
    if (m == null) {
      print('app model is null');
      return AppModel.emptyModel();
    } else {
      return AppModel.fromJson(json.decode(m));
    }
  }

  // throws exception on unsuccess
  Future<File> exportToFile(AppModel model, File file) async {
    return file.writeAsString(await exportAsJsonString(model));
  }

  Future<String> exportAsJsonString(AppModel model) async {
    return json.encode(model.toJson());
  }

  AppModel importJsonString(String jsonStr) {
    // XXX: Throws exception on issue
    AppModel model = AppModel.fromJson(json.decode(jsonStr));
    _model = model;
    saveModel(model);
    return _model!;
  }
}
