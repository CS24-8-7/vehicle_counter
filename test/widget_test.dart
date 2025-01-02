// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class VehicleCounterProvider extends ChangeNotifier {
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
    'motor': 'Motor',
  };

  Map<String, Map<String, int>> get counters => _counters;
  Map<String, String> get vehicleLabels => _vehicleLabels;

  VehicleCounterProvider() {
    _loadCounters();
  }

  void incrementCounter(String vehicleType, String direction) {
    if (_counters.containsKey(vehicleType)) {
      _counters[vehicleType]?[direction] =
          (_counters[vehicleType]?[direction] ?? 0) + 1;
      notifyListeners();
      _saveCounters();
    }
  }

  void resetCounters() {
    _counters.forEach((vehicleType, directions) {
      directions.updateAll((direction, _) => 0);
    });
    notifyListeners();
    _saveCounters();
  }

  void addVehicle(String vehicleType) {
    if (vehicleType.isNotEmpty && !_counters.containsKey(vehicleType)) {
      _counters[vehicleType] = {
        'North': 0,
        'East': 0,
        'West': 0,
        'South': 0,
      };
      _vehicleLabels[vehicleType] = vehicleType;
      notifyListeners();
      _saveCounters();
    }
  }

  void removeVehicle(String vehicleType) {
    _counters.remove(vehicleType);
    _vehicleLabels.remove(vehicleType);
    notifyListeners();
    _saveCounters();
  }

  Future<void> _saveCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final countersJson = _counters.map((key, value) {
      return MapEntry(key, jsonEncode(value));
    });
    await prefs.setString('counters', jsonEncode(countersJson));
  }

  Future<void> _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final countersString = prefs.getString('counters');
    if (countersString != null) {
      final Map<String, dynamic> decoded = jsonDecode(countersString);
      decoded.forEach((key, value) {
        _counters[key] = Map<String, int>.from(jsonDecode(value));
      });
      notifyListeners();
    } else {}
  }
}
