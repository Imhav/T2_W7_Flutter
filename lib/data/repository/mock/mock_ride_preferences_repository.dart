import '../../../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class MockRidePreferencesRepository extends RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = [];

  @override
  Future<List<RidePreference>> getPastPreferences() {
    return Future.delayed(const Duration(seconds: 10), () {
      return _pastPreferences;
    });
  }

  @override
  Future<void> addPreference(RidePreference preference) {
    return Future.delayed(const Duration(seconds: 10), () {
      return _pastPreferences.add(preference);
    });
  }
}
