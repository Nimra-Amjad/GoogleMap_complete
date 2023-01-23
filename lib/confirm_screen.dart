import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  String pickup_address;
  String dropoff_location;
  ConfirmScreen({
    Key? key,
    required this.pickup_address,
    required this.dropoff_location,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text(
            "Pickup Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.pickup_address,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Dropoff Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.dropoff_location,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      )),
    );
  }
}
