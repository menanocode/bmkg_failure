import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsService {
  static const String apiUrl =
      'http://127.0.0.1:5000/api/teknologi'; // URL API berita

  static Future<List<dynamic>> fetchNewsData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Kembalikan data sebagai daftar JSON
    } else {
      throw Exception('Gagal memuat data berita');
    }
  }
}
