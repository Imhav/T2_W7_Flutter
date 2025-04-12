// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';

import '../repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferenceProvider extends ChangeNotifier {
  final RidePreferencesRepository repository;

  late AsyncValue<List<RidePreference>> pastPreference;

  RidePreference? _currentPreference;

  RidesPreferenceProvider({required this.repository}) {
    pastPreference = AsyncValue.loading();
    fetchPastPreferences();
  }

  RidePreference? get currentPreference {
    // print("Get current pref: $_currentPreference");
    return _currentPreference;
  }

  void setCurrentPreference(RidePreference preference) {
    if (_currentPreference != preference) {
      // print("Set current pref to $_currentPreference");
      _currentPreference = preference;
      addPreference(preference);
      notifyListeners();
    }
  }

  Future<void> addPreference(RidePreference preference) async {
    try {
      // 1. Add to the Repository
      await repository.addPreference(preference);

      // 2. Refetch data again
      await fetchPastPreferences();
    } catch (e) {
      pastPreference = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> fetchPastPreferences() async {
    // 1- Handle loading
    pastPreference = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch Data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();

      // 3- Handle Success
      pastPreference = AsyncValue.success(pastPrefs);

      // 4- Hanles Error
    } catch (e) {
      pastPreference = AsyncValue.error(e);
    }

    notifyListeners();
  }
}
