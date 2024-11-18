import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AboutScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  AboutScreen({required this.userEmail, required this.userPassword});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Map<String, dynamic>? userData;
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController domicileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/flutter_api/get_user.php'),
        body: {
          'email': widget.userEmail,
          'password': widget.userPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            userData = data;
            nameController.text = data['name'] ?? 'N/A';
            emailController.text = data['email'] ?? 'N/A';
            phoneController.text = data['phone'] ?? 'N/A';
            domicileController.text = data['domicile'] ?? 'N/A';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memuat data pengguna: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data pengguna')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateUserData() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/flutter_api/update_user.php'),
        body: {
          'email': widget.userEmail,
          'name': nameController.text,
          'phone': phoneController.text,
          'domicile': domicileController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            userData = {
              ...userData!,
              'name': nameController.text,
              'phone': phoneController.text,
              'domicile': domicileController.text,
            };
            isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil diperbarui!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal memperbarui data pengguna: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data pengguna')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
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
                  isEditing
                      ? Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration:
                                  InputDecoration(labelText: 'Nama Lengkap'),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              enabled: false, // Email tidak bisa diubah
                            ),
                            TextField(
                              controller: phoneController,
                              decoration:
                                  InputDecoration(labelText: 'Nomor Telepon'),
                            ),
                            TextField(
                              controller: domicileController,
                              decoration:
                                  InputDecoration(labelText: 'Domisili'),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: updateUserData,
                              child: Text('Simpan Perubahan'),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama Lengkap: ${userData!['name'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Email: ${userData!['email'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text(
                                'Nomor Telepon: ${userData!['phone'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Domisili: ${userData!['domicile'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: Text('Edit Data'),
                            ),
                          ],
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
