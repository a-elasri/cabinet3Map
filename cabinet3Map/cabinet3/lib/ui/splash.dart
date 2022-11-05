import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/directions_handler.dart';
import '../main.dart';
import '../requests/globals.dart';
import '../requests/mapbox_requests.dart';
import '../screens/home_management.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get capture the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLatLng =
    LatLng(_locationData.latitude!, _locationData.longitude!);



    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
    print(_locationData.latitude);
    print(_locationData.longitude);

    GetListCabinets(currentLatLng).then((value) async {

        for (int i = 0; i < cabinets.length; i++) {
          Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
          saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
        }

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeManagement()),
                (route) => false);

    });

    print(".........hello............."+cabinets.length.toString());
    // Get and store the directions API response in sharedPreferences


    // Timer(Duration(seconds: 5),() async {
    //   for (int i = 0; i < cabinets.length; i++) {
    //     Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
    //     saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    //   }
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (_) => const HomeManagement()),
    //           (route) => false);
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(child: Image.asset('assets/image/image.png')),
    );
  }

}