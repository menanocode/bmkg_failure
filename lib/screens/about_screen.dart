import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'This is an Earthquake Checker app that fetches earthquake data from BMKG API.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
