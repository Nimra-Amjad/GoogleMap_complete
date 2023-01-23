import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:text_boxes_pickup_dropoff/dropoff_location.dart';

class PickUpLocation extends StatefulWidget {
  String address_name;
  double lattitude;
  double longitude;
  PickUpLocation({
    Key? key,
    required this.address_name,
    required this.lattitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<PickUpLocation> createState() => _PickUpLocationState();
}

class _PickUpLocationState extends State<PickUpLocation> {
  String pickup_location = "Pickup Location";
  double lat = 0.0;
  double long = 0.0;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(widget.lattitude, widget.longitude),
        infoWindow: InfoWindow(title: widget.address_name))
  ];

  Future<Position> getusercurrentlocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  final snackBar = SnackBar(
    content: const Text('Please select pickup location'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: pickup_location,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: GestureDetector(
                onTap: () {
                  pickup_location == "Pickup Location"
                      ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DropOffLocation(
                                  pickup_address: pickup_location,
                                  address_name: pickup_location,
                                  lattitude: lat,
                                  longitude: long)));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.blue),
                  width: double.infinity,
                  height: 60,
                  child: Text(
                    "Pick drop off location",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                onTap: (LatLng latLng) async {
                  getusercurrentlocation().then((value) async {
                    final coordinates = await placemarkFromCoordinates(
                        latLng.latitude, latLng.longitude);
                    Placemark place = coordinates[0];
                    print(coordinates);
                    print(place);
                    final add =
                        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                    print("Address: ${add}");
                    print("my current location");
                    print(value.latitude.toString() +
                        " " +
                        value.longitude.toString());
                    _markers.add(Marker(
                        markerId: MarkerId('1'),
                        position: latLng,
                        infoWindow: InfoWindow(title: '${add}')));
                    CameraPosition cameraposition = CameraPosition(
                        zoom: 14,
                        target: LatLng(latLng.latitude, latLng.longitude));
                    final GoogleMapController controller =
                        await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraposition));

                    setState(() {
                      pickup_location = add;
                      lat = latLng.latitude;
                      long = latLng.longitude;
                    });
                  });
                  print(latLng);
                  setState(() {});
                },
                markers: Set<Marker>.of(_markers),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lattitude, widget.longitude),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
