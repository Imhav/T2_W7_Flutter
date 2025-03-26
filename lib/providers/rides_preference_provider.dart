import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferenceProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferenceProvider({required this.repository}) {
    // For now, past preferences are fetched only 1 time in the constructor
    _pastPreferences = repository.getPastPreferences();
    // We no longer fetch _currentPreference from the repository
    // It will start as null and be set when the user selects a pref
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference == pref) {
      return;
    }

    _currentPreference = pref;
    _addPreference(pref);
    notifyListeners();
  }

  void _addPreference(RidePreference preference) {
    // Remove any existing preference that is equal to the new one
    // This ensures all preferences in the history are exclusive (different)
    _pastPreferences.removeWhere((existingPref) => existingPref == preference);

    // Add the new preference to the list (this will be the newest)
    _pastPreferences.add(preference);

    // Save the preference to the repository
    repository.addPreference(preference);
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();
}
