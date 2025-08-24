import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleCounterProvider extends ChangeNotifier {
  static const _countersKey = 'counters';
  static const _labelsKey = 'vehicle_labels';

  final SharedPreferences _prefs;

  VehicleCounterProvider(this._prefs) {
    _load();
  }

  final Map<String, Map<String, int>> _counters = {
    'bus': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
    'car': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
    'van': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
    'truck': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
    'taxi': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
    'motor': {'North': 0, 'East': 0, 'West': 0, 'South': 0},
  };

  final Map<String, String> _vehicleLabels = {
    'bus': 'Bus',
    'car': 'Car',
    'van': 'Van',
    'truck': 'Truck',
    'taxi': 'Taxi',
    'motor': 'Motorcycle',
  };

  Map<String, Map<String, int>> get counters => _counters;
  Map<String, String> get vehicleLabels => _vehicleLabels;

  void incrementCounter(String vehicleType, String direction) {
    if (!_counters.containsKey(vehicleType)) return;
    final current = _counters[vehicleType]?[direction] ?? 0;
    _counters[vehicleType]![direction] = current + 1;
    _save();
    notifyListeners();
  }

  void resetCounters() {
    for (final entry in _counters.entries) {
      entry.value.updateAll((key, value) => 0);
    }
    _save();
    notifyListeners();
  }

  bool addVehicle(String vehicleType) {
    final key = vehicleType.trim();
    if (key.isEmpty) return false;
    final normalized = key.toLowerCase();
    if (_counters.containsKey(normalized)) return false;

    _counters[normalized] = {'North': 0, 'East': 0, 'West': 0, 'South': 0};
    _vehicleLabels[normalized] = _toTitleCase(key);
    _save();
    notifyListeners();
    return true;
  }

  void removeVehicle(String vehicleType) {
    _counters.remove(vehicleType);
    _vehicleLabels.remove(vehicleType);
    _save();
    notifyListeners();
  }

  String _toTitleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void _save() {
    final countersJson = jsonEncode(_counters);
    final labelsJson = jsonEncode(_vehicleLabels);
    _prefs.setString(_countersKey, countersJson);
    _prefs.setString(_labelsKey, labelsJson);
  }

  void _load() {
    final countersString = _prefs.getString(_countersKey);
    final labelsString = _prefs.getString(_labelsKey);

    if (countersString != null) {
      try {
        final decoded = jsonDecode(countersString) as Map<String, dynamic>;
        decoded.forEach((k, v) {
          _counters[k] = Map<String, int>.from((v as Map).map(
            (key, val) => MapEntry(key.toString(), int.parse(val.toString())),
          ));
        });
      } catch (_) {}
    }

    if (labelsString != null) {
      try {
        final decoded = jsonDecode(labelsString) as Map<String, dynamic>;
        decoded.forEach((k, v) {
          _vehicleLabels[k] = v.toString();
        });
      } catch (_) {}
    }
  }
}
