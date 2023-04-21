import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:water_me/models/group_model.dart';
import 'package:water_me/models/plant_model.dart';

class AppModel extends ChangeNotifier {
  List<GroupModel> _groups = [];

  static emptyModel() {
    GroupModel group = GroupModel("My plants");
    AppModel model = AppModel();
    model._groups.add(group);
    return model;
  }

  GroupModel get defaultGroup {
    if (_groups.isEmpty) {
      addGroup(GroupModel("My plants"));
    }
    return _groups[0];
  }

  set groups(List<GroupModel> l) {
    _groups = l;
    notifyListeners();
  }

  List<GroupModel> get groups {
    return _groups;
  }

  List<PlantModel> get allPlants {
    return _groups.expand((g) => g.plants).toList();
  }

  List<PlantModel> get plantsOrderedByWatering {
    var p = allPlants;
    p.sort((a, b) {
      return a.daysUntilNextWatering().compareTo(b.daysUntilNextWatering());
    });
    return p;
  }

  int plantsToWater() {
    return allPlants.where((p) => p.isWateringDue()).toList().length;
  }

  bool isWateringDue() {
    for (var p in allPlants) {
      if (p.isWateringDue()) {
        return true;
      }
    }
    return false;
  }

  void addGroup(GroupModel g) {
    _groups.add(g);
    notifyListeners();
    g.addListener(notifyParent);
  }

  void notifyParent() {
    // XXX: We have to change UI logic in parent if a child changes,
    // so parent is interested in changes of child,
    // this is relevant for sort ordering of plant list
    notifyListeners();
  }

  // workaround until group feature implemented
  List<PlantModel> get plants => allPlants;

  void addPlant(PlantModel m) {
    defaultGroup.addPlant(m);
  }

  removePlant(PlantModel m) {
    defaultGroup.removePlant(m);
  }

  static AppModel fromJson(Map<String, dynamic> json) {
    AppModel model = AppModel();
    var version = json['version'] ?? '';

    // XXX: in version 1 we had no groups yet
    if (version == '1') {
      var group = GroupModel("My Plants");
      var plants = List<Map<String, dynamic>>.from(json['plants']);
      for (var plantMap in plants) {
        group.addPlant(PlantModel.fromJson(plantMap));
      }
      model.addGroup(group);
    } else {
      var groups = List<Map<String, dynamic>>.from(json['groups']);
      for (var groupMap in groups) {
        model.addGroup(GroupModel.fromJson(groupMap));
      }
    }
    return model;
  }

  /*
   * version 1: init
   * version 2: group support
   */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groups'] = groups.map((e) => e.toJson()).toList();
    data['version'] = '2';
    return data;
  }
}
