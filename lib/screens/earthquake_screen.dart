import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/scheduler.dart'; // Import the scheduler package

class EarthquakeScreen extends StatefulWidget {
  @override
  _EarthquakeScreenState createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<EarthquakeScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? earthquakeData;
  late AudioPlayer _audioPlayer;
  bool _isAlarmActive = false;
  bool _isScreenFlashing = false; // Flag for screen flashing
  late Ticker _ticker; // Ticker for controlling the flashing
  int _flashCount = 0; // Count of flashes

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
      final response = await http.get(
          Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          earthquakeData = data['Infogempa']['gempa'];
        });

        // Trigger alarm if magnitude > 5.0
        if (earthquakeData != null) {
          double magnitude = double.parse(earthquakeData!['Magnitude']);
          if (magnitude > 5.0 && !_isAlarmActive) {
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
      _isScreenFlashing = true; // Start flashing the screen
    });

    // Play alarm sound
    await _audioPlayer.setSource(AssetSource('assets/earthquake_alarm.mp3'));
    _audioPlayer.setVolume(1.0);
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('assets/earthquake_alarm.mp3'));

    // Start vibration
    if (earthquakeData != null && earthquakeData!['Magnitude'] != null) {
      double magnitude = double.parse(earthquakeData!['Magnitude']);
      if (magnitude > 5.0 && !_isAlarmActive) {
        _triggerEarthquakeAlarm();
      }
    }

    // Start flashing the screen
    _flashCount = 0;
    _ticker = Ticker(_onTick); // Initialize Ticker
    _ticker.start();
  }

  // Control flashing of screen
  void _onTick(Duration duration) {
    if (_flashCount < 10) {
      // Flash for 10 cycles
      setState(() {
        _isScreenFlashing = !_isScreenFlashing; // Toggle the flashing
      });
      _flashCount++;
    } else {
      _ticker.stop();
      setState(() {
        _isScreenFlashing = false; // Stop flashing after 10 cycles
      });
    }
  }

  // Stop earthquake alarm
  void _stopEarthquakeAlarm() async {
    await _audioPlayer.stop();
    setState(() {
      _isAlarmActive = false;
      _isScreenFlashing = false; // Stop flashing
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
    _triggerEarthquakeAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gempa Terbaru'),
      ),
      body: earthquakeData == null
          ? Center(child: CircularProgressIndicator())
          : AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: _isScreenFlashing
                  ? Colors.red
                  : Colors.transparent, // Red flash effect
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${earthquakeData!['Tanggal']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
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
                                Text('Peta Shakemap:',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Image.network(
                                    'https://data.bmkg.go.id/DataMKG/TEWS/${earthquakeData!['Shakemap']}',
                                    errorBuilder: (context, error, stackTrace) {
                                  return Text('Gambar tidak dapat dimuat');
                                }),
                              ],
                            )
                          : Text('Shakemap tidak tersedia'),

                      // Simulasi gempa
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _simulateEarthquake,
                        child: Text('Simulasikan Gempa'),
                      ),

                      // Peringatan gempa jika magnitudo > 5.0
                      if (_isAlarmActive)
                        AlertDialog(
                          title: Text('Peringatan Gempa!'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Gempa dengan Magnitudo lebih dari 5.0 Detected!'),
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
            ),
    );
  }
}
