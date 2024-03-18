import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WateringMode {
  final String _key;
  final String _text;
  IconData? _icon;

  WateringMode(String this._key, String this._text, {IconData? icon = null}) {
    _icon = icon;
  }

  get text => _text;

  get key => _key;

  get icon => _icon;
}

class WateringModes {
  static List<WateringMode> wateringModes = [
    WateringMode("water_on_top", "Pour water on the soil, near the roots",
        icon: Icons.water_drop),
    WateringMode(
        "soak", "Pour water on top until it streams out from the bottom",
        icon: Icons.shower),
    WateringMode("mist", "Spray mist over the plant"),
    WateringMode("absorb_via_dish",
        "Place the plant and pot in a bowl with a few centimeters of water, let it drink",
        icon: Icons.water),
    WateringMode("bathe", "Put the entire plant in water for a while",
        icon: Icons.hot_tub),
  ];

  static WateringMode? get(String wateringMethod) {
    for (WateringMode wm in WateringModes.wateringModes) {
      if (wm.key == wateringMethod) {
        return wm;
      }
    }
    return null;
  }
}
