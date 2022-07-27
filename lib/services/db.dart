import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_model.dart';

class Db {
  AppModel? _model;

  get model async {
    _model ??= await loadModel();
    return _model;
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
      return AppModel();
    } else {
      return AppModel.fromJson(json.decode(m));
    }
  }
}
