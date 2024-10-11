import 'package:flutter/material.dart';

class EarthquakeCard extends StatelessWidget {
  final String magnitude;
  final String location;
  final String time;

  EarthquakeCard(
      {required this.magnitude, required this.location, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text('Magnitudo: $magnitude'),
        subtitle: Text('Lokasi: $location\nWaktu: $time'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
