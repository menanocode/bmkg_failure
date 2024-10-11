import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EarthquakeScreen extends StatefulWidget {
  @override
  _EarthquakeScreenState createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<EarthquakeScreen> {
  Map<String, dynamic>? earthquakeData;

  @override
  void initState() {
    super.initState();
    fetchEarthquakeData();
  }

  Future<void> fetchEarthquakeData() async {
    try {
      // BMKG earthquake API endpoint
      final response = await http.get(
          Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));
      print('Respons mentah API: ${response.body}'); // Log API response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          earthquakeData =
              data['Infogempa']['gempa']; // Parsing earthquake data
        });
      } else {
        throw Exception('Gagal memuat data gempa');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gempa Terbaru'),
      ),
      body: earthquakeData == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanggal: ${earthquakeData!['Tanggal']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Jam: ${earthquakeData!['Jam']}'),
                  SizedBox(height: 8),
                  Text('Magnitude: ${earthquakeData!['Magnitude']}'),
                  SizedBox(height: 8),
                  Text('Kedalaman: ${earthquakeData!['Kedalaman']}'),
                  SizedBox(height: 8),
                  Text('Wilayah: ${earthquakeData!['Wilayah']}'),
                  SizedBox(height: 8),
                  Text('Potensi: ${earthquakeData!['Potensi']}'),
                  SizedBox(height: 8),
                  Text('Koordinat: ${earthquakeData!['Coordinates']}'),
                  SizedBox(height: 16),
                  earthquakeData!['Shakemap'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peta Shakemap:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Image.network(
                              'https://data.bmkg.go.id/DataMKG/TEWS/${earthquakeData!['Shakemap']}',
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Gambar tidak dapat dimuat');
                              },
                            ),
                          ],
                        )
                      : Text('Shakemap tidak tersedia'),
                ],
              ),
            ),
    );
  }
}
