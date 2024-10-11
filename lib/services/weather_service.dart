import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  static const String apiUrl =
      'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=31.73.01.1001';

  static Future<List<dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'][0]['cuaca']; // Mengakses cuaca dari respons JSON
    } else {
      throw Exception('Gagal memuat data cuaca');
    }
  }
}
