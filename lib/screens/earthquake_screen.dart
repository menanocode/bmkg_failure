import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class EarthquakeScreen extends StatefulWidget {
  @override
  _EarthquakeScreenState createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<EarthquakeScreen> {
  Map<String, dynamic>? earthquakeData;
  late AudioPlayer _audioPlayer;
  bool _isAlarmActive = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchEarthquakeData();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
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

        // Trigger alarm if magnitude > 7.0
        if (earthquakeData != null) {
          double magnitude = double.parse(earthquakeData!['Magnitude']);
          if (magnitude > 7.0 && !_isAlarmActive) {
            _triggerEarthquakeAlarm();
          }
        }
      } else {
        throw Exception('Gagal memuat data gempa');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Trigger earthquake alarm
  void _triggerEarthquakeAlarm() async {
    setState(() {
      _isAlarmActive = true;
    });
    // Memuat dan memutar alarm audio
    try {
      await _audioPlayer.setAsset('assets/earthquake_alarm.mp3');
      _audioPlayer.setVolume(1.0);
      _audioPlayer.setLoopMode(LoopMode.one); // Set untuk looping
      await _audioPlayer.play(); // Memutar audio tanpa argumen
    } catch (e) {
      print('Error saat memutar audio: $e');
    }
  }

  // Stop alarm sound
  void _stopEarthquakeAlarm() async {
    await _audioPlayer.stop();
    setState(() {
      _isAlarmActive = false;
    });
  }

  // Simulate an earthquake for testing
  void _simulateEarthquake() {
    setState(() {
      earthquakeData = {
        'Tanggal': '2024-12-04',
        'Jam': '12:00:00',
        'Magnitude': '6.5',
        'Kedalaman': '10 km',
        'Wilayah': 'Lombok, NTB',
        'Potensi': 'Berpotensi Tsunami',
        'Coordinates': '8.340, 116.457',
        'Shakemap': 'shakemap_earthquake.png',
      };
    });

    // Trigger alarm for simulation
    _triggerEarthquakeAlarm();
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
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal: ${earthquakeData!['Tanggal']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                    // Simulasi gempa
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _simulateEarthquake,
                      child: Text('Simulasi Gempa'),
                    ),

                    // Putar audio alarm gempa
                    SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     print('Memutar audio langsung');
                    //     try {
                    //       await _audioPlayer
                    //           .play(); // Memutar audio tanpa argument
                    //       print('Audio dimulai');
                    //     } catch (e) {
                    //       print('Error saat memutar audio: $e');
                    //     }
                    //   },
                    //   child: Text('Putar Audio Alarm'),
                    // ),

                    // Peringatan gempa jika magnitudo > 5.0
                    if (_isAlarmActive)
                      AlertDialog(
                        title: Text('Peringatan Gempa!'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Gempa dengan Magnitudo lebih dari 7.0 Detected!'),
                            SizedBox(height: 10),
                            Text('Segera lakukan tindakan evakuasi.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: _stopEarthquakeAlarm,
                            child: Text('OK'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
