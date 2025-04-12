import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../providers/async_value.dart';
import '../../../providers/rides_preference_provider.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  onRidePrefSelected(RidePreference newPreference, BuildContext context) async {
    // 1 - Update the current preference
    final prefProvider = context.read<RidesPreferenceProvider>();
    prefProvider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final prefProvider = context.watch<RidesPreferenceProvider>();
    RidePreference? currentRidePreference = prefProvider.currentPreference;

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (preference) {
                      onRidePrefSelected(preference, context);
                    },
                  ),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                      height: 200, // Set a fixed height
                      child: _buildPastRidePrefListView(prefProvider, context)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPastRidePrefListView(
      RidesPreferenceProvider provider, BuildContext context) {
    final ridePrefValue = provider.pastPreference;

    switch (ridePrefValue.state) {
      case AsyncValueState.loading:
        return Center(child: CircularProgressIndicator());

      case AsyncValueState.error:
        return Text('Error: ${ridePrefValue.error}');

      case AsyncValueState.success:
        if (ridePrefValue.data == null || ridePrefValue.data!.isEmpty) {
          return Center(child: Text("No past preferences found."));
        }

        return ListView.builder(
          shrinkWrap: true, // Fix ListView height issue
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: ridePrefValue.data!.length,
          itemBuilder: (ctx, index) => RidePrefHistoryTile(
            ridePref: ridePrefValue.data![index],
            onPressed: () =>
                onRidePrefSelected(ridePrefValue.data![index], context),
          ),
        );
    }
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}