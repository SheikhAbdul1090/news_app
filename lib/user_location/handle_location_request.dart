import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
    }
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      }
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
    }
    return false;
  }
  return true;
}

Future<String?> getCurrentUserPosition(BuildContext context) async {
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return null;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) async {
    return await _getAddressFromLatLng(position);
  }).catchError((e) {
    debugPrint(e);
  });
  return null;
}

Future<String?> _getAddressFromLatLng(Position position) async {
  await placemarkFromCoordinates(position.latitude, position.longitude)
      .then((List<Placemark> placeMarks) {
    return placeMarks[0].isoCountryCode?.toLowerCase();
  }).catchError((e) {
    debugPrint(e);
  });
  return null;
}
