import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic>? newsData;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/api/teknologi'));
      print('Respons API berita: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          newsData = data; // Setel data API ke newsData
        });
      } else {
        print('Gagal memuat berita');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Teknologi Terbaru'),
      ),
      body: newsData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsData?.length ?? 0,
              itemBuilder: (context, index) {
                final news = newsData![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(news['judul']),
                    subtitle: Text(news['tanggal']),
                    onTap: () {
                      _launchURL(news['link']);
                    },
                  ),
                );
              },
            ),
    );
  }

  // Function to open the URL in the browser
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Tidak dapat membuka $url');
        throw 'Tidak dapat membuka $url';
      }
    } catch (e) {
      print('Error saat membuka URL: $e');
    }
  }
}
