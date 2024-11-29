import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/view/widgets/loader_button.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

import '../../utills/snippets.dart';
import '../splash/splash_view.dart';

class PermissionView extends StatefulWidget {
  const PermissionView({Key? key}) : super(key: key);

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 90, color: primaryColor),
              const SizedBox(height: 25),
              Text(
                """Service Provider App requires your permission for tracking, kindly enable the permission """,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              LoaderButton(
                  btnText: "Click Here",
                  onTap: () async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (permission == LocationPermission.deniedForever) {
                      if (!mounted) return;
                      snack(context,
                          "Please enable location permission manually.");
                    } else if (permission == LocationPermission.denied) {
                      // Location permission denied, open app settings to enable permission.
                      await Geolocator.openAppSettings();
                    } else {
                      if (!mounted) return;
                      snack(context,
                          "Location permission already granted or not determined.");
                    }
                  }),
              const SizedBox(height: 25),
              LoaderButton(
                  btnText: "Done",
                  color: whiteColor,
                  radius: 4,
                  borderSide: secondaryColor,
                  textColor: secondaryColor,
                  onTap: () async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();
                    if (!mounted) return;
                    if (permission == LocationPermission.deniedForever) {
                      snack(context,
                          "Please enable location permission manually.");
                    } else if (permission == LocationPermission.denied) {
                      snack(context,
                          "Please enable location permission in app settings.");
                    } else {
                      bool backgroundModeEnabled =
                          await Geolocator.isLocationServiceEnabled();

                      if (backgroundModeEnabled) {
                        if (!mounted) return;
                        replace(context, const SplashView());
                      } else {
                        if (!mounted) return;
                        snack(context,
                            "Please enable background mode in app settings.");
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
