import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final data = await WeatherService.fetchWeatherData();
      print('Respons API Cuaca: $data'); // Log untuk melihat struktur data
      setState(() {
        weatherData = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuaca Hari Ini'),
      ),
      body: weatherData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: weatherData?.length ?? 0,
              itemBuilder: (context, index) {
                final sublist =
                    weatherData![index]; // Mengakses sublist data cuaca
                return Column(
                  children: List.generate(sublist.length, (subIndex) {
                    final weather = sublist[subIndex];

                    // Mengambil datetime dan mengubah formatnya
                    DateTime dateTime =
                        DateTime.parse(weather['local_datetime']);
                    String formattedDate =
                        "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal: $formattedDate',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            weather['image'] != null &&
                                    weather['image'].isNotEmpty
                                ? Image.network(
                                    weather['image'],
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image,
                                          size: 50, color: Colors.grey);
                                    },
                                  )
                                : Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                            SizedBox(height: 8.0),
                            Text('Suhu: ${weather['t']}°C'),
                            Text('Kelembapan: ${weather['hu']}%'),
                            Text('Kondisi Cuaca: ${weather['weather_desc']}'),
                            Text('Kecepatan Angin: ${weather['ws']} km/jam'),
                            Text(
                                'Arah Angin: ${weather['wd']} (${weather['wd_deg']}°)'),
                            Text('Tutupan Awan: ${weather['tcc']}%'),
                            Text('Jarak Pandang: ${weather['vs_text']}'),
                            SizedBox(height: 8.0),
                            Text(
                              'Lokasi: Cengkareng, Jakarta Barat',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
    );
  }
}
