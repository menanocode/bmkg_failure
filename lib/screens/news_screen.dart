import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../services/news_webview.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsData = [];
  bool isLoading = true; // Untuk menampilkan indikator loading

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final String apiUrl = 'https://www.cnnindonesia.com/internasional/rss';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(
            response.body); // Menggunakan XmlDocument.parse untuk parsing XML
        final items = document.findAllElements('item');
        final newsList = items.map((item) {
          final title = item.findElements('title').single.text;
          final link = item.findElements('link').single.text;
          final pubDate = item.findElements('pubDate').single.text;
          final description = item.findElements('description').single.text;
          final imageUrl = item.findElements('enclosure').isNotEmpty
              ? item.findElements('enclosure').first.getAttribute('url')
              : null;
          return {
            'judul': title,
            'tanggal': pubDate,
            'link': link,
            'gambar': imageUrl,
            'deskripsi': description,
          };
        }).toList();
        setState(() {
          newsData = newsList;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data berita');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat berita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Terbaru'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : newsData.isEmpty
              ? Center(child: Text('Tidak ada berita yang tersedia.'))
              : ListView.builder(
                  itemCount: newsData.length,
                  itemBuilder: (context, index) {
                    final news = newsData[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: news['gambar'] != null
                            ? Image.network(
                                news['gambar'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : null,
                        title: Text(news['judul'] ?? 'Judul tidak tersedia'),
                        subtitle:
                            Text(news['tanggal'] ?? 'Tanggal tidak tersedia'),
                        onTap: () {
                          if (news['link'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsWebView(url: news['link']),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Link tidak tersedia untuk berita ini')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
