import 'package:http/http.dart' as http;
import 'dart:convert';

class EarthquakeService {
  static const String apiUrl =
      'https://data.bmkg.go.id/gempabumi/'; // URL API Gempa BMKG

  static Future<List<dynamic>> fetchEarthquakeData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['infogempa']['gempa']; // Pastikan struktur JSON benar
    } else {
      throw Exception('Gagal memuat data gempa');
    }
  }
}
