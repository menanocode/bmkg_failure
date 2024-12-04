import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

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
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController no_hpController = TextEditingController();
  final TextEditingController domisiliController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.125.95/flutter_api/get_user.php'),
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
            namaController.text = data['nama'] ?? 'N/A';
            emailController.text = data['email'] ?? 'N/A';
            no_hpController.text = data['no_hp'] ?? 'N/A';
            domisiliController.text = data['domisili'] ?? 'N/A';
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
        Uri.parse('http://192.168.125.95/flutter_api/update_user.php'),
        body: {
          'email': widget.userEmail,
          'nama': namaController.text,
          'no_hp': no_hpController.text,
          'domisili': domisiliController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            userData = {
              ...userData!,
              'nama': namaController.text,
              'no_hp': no_hpController.text,
              'domisili': domisiliController.text,
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

  Future<void> deleteUserAccount() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.125.95/flutter_api/delete_user.php'),
        body: {
          'email': widget.userEmail,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Akun berhasil dihapus!')),
          );

          // Arahkan kembali ke LoginScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // Hapus semua rute sebelumnya
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus akun: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus akun')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan Akun'),
          content: Text('Apakah Anda yakin ingin menghapus akun ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteUserAccount();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                              controller: namaController,
                              decoration:
                                  InputDecoration(labelText: 'Nama Lengkap'),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              enabled: false, // Email tidak bisa diubah
                            ),
                            TextField(
                              controller: no_hpController,
                              decoration:
                                  InputDecoration(labelText: 'Nomor Telepon'),
                            ),
                            TextField(
                              controller: domisiliController,
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
                            Text('Nama Lengkap: ${userData!['nama'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Email: ${userData!['email'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text(
                                'Nomor Telepon: ${userData!['no_hp'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16)),
                            Text('Domisili: ${userData!['domisili'] ?? 'N/A'}',
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
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _showDeleteConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 242, 198, 198)),
                              child: Text('Request Hapus Akun'),
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
