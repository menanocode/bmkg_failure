import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Aplikasi Gempa dan Cuaca ini memberikan informasi terkini '
              'tentang cuaca dan gempa bumi di wilayah yang dipilih. '
              'Pengguna dapat mengecek berita terbaru dan informasi dari BMKG. '
              'Aplikasi ini dibuat untuk membantu pengguna agar tetap waspada '
              'dan mendapatkan informasi yang akurat terkait cuaca dan gempa bumi.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            Text(
              'Pengembang',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Nama Kelompok: Tarik air vs Everybody\n'
              'Email: iniemail@email.com\n'
              'Website: iniwebsite.co.id',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Versi Aplikasi: 1.0.0',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
