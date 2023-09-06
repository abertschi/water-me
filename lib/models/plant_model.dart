import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class PlantModel extends ChangeNotifier {
  List<DateTime> _wateringHistory = [];
  late String _plantName;
  late int _wateringFrequency;
  Uint8List? _image; // Image as Bytes

  PlantModel(String name, int wateringFreq) {
    _plantName = name;
    _wateringFrequency = wateringFreq;
  }

  get hasImage {
    return _image != null && _image!.isNotEmpty;
  }

  bool isWateringDue() {
    return daysUntilNextWatering() <= 0;
  }

  int? daysSinceLastWatered() {
    var last = lastWatered();
    if (last == null) return null;
    var now = DateTime.now();
    var diff = _differenceBetweenDates(now, last).inDays;
    return diff;
  }

  Duration _differenceBetweenDates(DateTime d1, DateTime d2) {
    var _d1 = DateTime(d1.year, d1.month, d1.day);
    var _d2 = DateTime(d2.year, d2.month, d2.day);
    return _d1.difference(_d2);
  }

  int daysUntilNextWatering() {
    var last = lastWatered();
    if (last == null) {
      return 0;
    } else {
      var now = DateTime.now();
      var diff = _differenceBetweenDates(now, last).inDays;
      return wateringFrequency - diff;
    }
  }

  String get plantName => _plantName;

  set plantName(String p) {
    _plantName = p;
    notifyListeners();
  }

  List<DateTime> get wateringHistory => _wateringHistory;

  set wateringHistory(List<DateTime> hist) {
    _wateringHistory = hist;
    notifyListeners();
  }

  DateTime? lastWatered() {
    if (_wateringHistory.isEmpty) return null;
    return _wateringHistory.last;
  }

  void waterNow() {
    wateringHistory.add(DateTime.now());
    notifyListeners();
  }

  undoWatering() {
    if (wateringHistory.isNotEmpty) {
      wateringHistory.removeLast();
    }
    notifyListeners();
  }

  Uint8List? get image => _image;

  set image(Uint8List? i) {
    _image = i;
    notifyListeners();
  }

  int get wateringFrequency => _wateringFrequency;

  set wateringFrequency(int f) {
    _wateringFrequency = f;
    notifyListeners();
  }

  static PlantModel fromJson(Map<String, dynamic> plantMap) {
    PlantModel p = PlantModel("", 0);
    p.plantName = plantMap['name'] ?? '';
    p.wateringFrequency = plantMap['frequency'] ?? 7;

    var encodedImage = plantMap['image'];
    if (encodedImage != null) p.image = base64Decode(encodedImage);

    var hist = List<String>.from(plantMap['watinergHistory'] ?? []);
    p.wateringHistory = hist.map((e) => DateTime.parse(e)).toList();
    return p;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = plantName;
    data['frequency'] = wateringFrequency;
    if (image != null) data['image'] = base64Encode(image!);
    data['watinergHistory'] = wateringHistory.map((e) => e.toString()).toList();
    return data;
  }

  @override
  String toString() {
    return "{$plantName: ${lastWatered()?.toIso8601String()}}";
  }
}
