import 'package:flutter/foundation.dart';
import 'package:water_me/models/plant_model.dart';

class AppModel extends ChangeNotifier {
  List<PlantModel> _plants = [];

  set plants(List<PlantModel> l) {
    _plants = l;
    notifyListeners();
  }

  List<PlantModel> get plants => plantsOrderedByWatering;

  List<PlantModel> get plantsOrderedByWatering {
    _plants.sort((a, b) {
      return a.daysUntilNextWatering().compareTo(b.daysUntilNextWatering());
    });
    return _plants;
  }

  bool isWateringDue() {
    for (var p in _plants) {
      if (p.isWateringDue()) {
        return true;
      }
    }
    return false;
  }

  void addPlant(PlantModel p) {
    _plants.add(p);
    notifyListeners();
    p.addListener(notifyParent);
  }

  void notifyParent() {
    // XXX: We have to change UI logic in parent if a child changes,
    // so parent is interested in changes of child
    notifyListeners();
  }

  void removePlant(PlantModel p) {
    _plants.remove(p);
    p.removeListener(notifyParent);
  }

  static AppModel fromJson(Map<String, dynamic> json) {
    AppModel model = AppModel();
    var plants = List<Map<String, dynamic>>.from(json['plants']);
    for (var plantMap in plants) {
      model.plants.add(PlantModel.fromJson(plantMap));
    }
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plants'] = plants.map((e) => e.toJson()).toList();
    data['version'] = '1';
    return data;
  }
}
