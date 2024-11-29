import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends ChangeNotifier {
  // current location
  LatLng? _currentLocation;
  LatLng? get currentLocation => _currentLocation;
  // markers
  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;
  // selectedAddress
  String _selectedAddress = '';
  String get selectedAddress => _selectedAddress;
  // LatLng
  LatLng? _latLng;
  LatLng? get latLng => _latLng;

  void setAddress(String? address) {
    _selectedAddress = address??'';
    notifyListeners();
  }

  void setLatLng(LatLng latlng) {
    _latLng = latlng;
    notifyListeners();
  }

  addMarker(LatLng latLng) async {
    clearMarkers();
    _markers.add(
      Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
      ),
    );
    Coordinates coordinates = Coordinates(latLng.latitude, latLng.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(
      coordinates,
    );
    setAddress(address.first.addressLine.toString());
    setLatLng(latLng);
    notifyListeners();
  }

  clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentLocation = LatLng(position.latitude, position.longitude);
    } else {
      _currentLocation = null;
    }

    notifyListeners();
  }
}
