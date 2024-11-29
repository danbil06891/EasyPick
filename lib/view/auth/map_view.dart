import 'dart:developer';

import 'package:easy_pick/states/map_state.dart';
import 'package:easy_pick/view/auth/components/show_map_address_widget.dart';
import 'package:easy_pick/view/auth/permission_view.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../utills/snippets.dart';

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleMapController? mapController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        leading: IconButton(
          onPressed: () => pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder(
          future: Provider.of<MapState>(context, listen: false)
              .getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Consumer<MapState>(
                builder: (context, mapState, child) {
                  return mapState.currentLocation == null
                      ? const PermissionView()
                      : Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                                log(mapController!.toString());
                              },
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              myLocationEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: mapState.currentLocation!,
                                zoom: 17,
                              ),
                              markers: mapState.markers,
                              onTap: (LatLng latLng) {
                                mapState.addMarker(latLng);
                              },
                            ),
                            mapState.selectedAddress == ''
                                ? Container()
                                : Positioned(
                                    bottom: 20,
                                    left: 20,
                                    right: 20,
                                    child: ShowMapAddressWidget(
                                        address: mapState.selectedAddress
                                            .toString()),
                                  )
                          ],
                        );
                },
              );
            }
          }),
    );
  }
}
