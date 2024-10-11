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
                    DateTime dateTime = DateTime.parse(weather['datetime']);
                    String formattedDate =
                        "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Suhu: ${weather['t']}°C'),
                        subtitle: Text('Kondisi: ${weather['weather_desc']}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                'Tanggal: $formattedDate'), // Menampilkan tanggal
                            Text(
                                'Lokasi: Cengkareng, Jakarta Barat'), // Menampilkan lokasi tetap
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
