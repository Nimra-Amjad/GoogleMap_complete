import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:text_boxes_pickup_dropoff/pickup_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Position> getusercurrentlocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GestureDetector(
          onTap: () async {
            getusercurrentlocation().then((value) async {
              final coordinates = await placemarkFromCoordinates(
                  value.latitude, value.longitude);
              Placemark place = coordinates[0];
              print(coordinates);
              print(place);
              final add =
                  '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
              print("my current location");
              print(
                  value.latitude.toString() + " " + value.longitude.toString());
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PickUpLocation(
                          address_name: add,
                          lattitude: value.latitude,
                          longitude: value.longitude)));
              setState(() {});
            });
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 60,
            child: Text("Show map"),
          ),
        ),
      )),
    );
  }
}
