import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:text_boxes_pickup_dropoff/confirm_screen.dart';

class DropOffLocation extends StatefulWidget {
  String pickup_address;
  String address_name;
  double lattitude;
  double longitude;
  DropOffLocation({
    Key? key,
    required this.pickup_address,
    required this.address_name,
    required this.lattitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<DropOffLocation> createState() => _DropOffLocationState();
}

class _DropOffLocationState extends State<DropOffLocation> {
  String dropoff_location = "Dropoff Location";

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
    content: const Text('Please select dropoff location'),
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: widget.pickup_address,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: dropoff_location,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: GestureDetector(
                onTap: () {
                  dropoff_location == "Dropoff Location"
                      ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmScreen(
                                  pickup_address: widget.pickup_address,
                                  dropoff_location: dropoff_location)));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.blue),
                  width: double.infinity,
                  height: 60,
                  child: Text(
                    "Confirm",
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
                      dropoff_location = add;
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
