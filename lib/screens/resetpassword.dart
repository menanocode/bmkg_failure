import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk mengirim permintaan reset password
  Future<void> _resetPassword() async {
    String email = _emailController.text;

    // Validasi form
    if (_formKey.currentState!.validate()) {
      try {
        // Kirim permintaan reset password ke server
        final response = await http.get(
          Uri.parse(
            'http://192.168.125.95/flutter_api/user_api.php?action=reset_password&email=$email',
          ),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          // Jika berhasil
          if (responseData['success'] == true) {
            // Menampilkan dialog pop-up setelah permintaan berhasil
            _showSuccessDialog();
          } else {
            // Jika gagal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Terjadi kesalahan: ${responseData['message']}')),
            );
          }
        } else {
          // Error server
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan pada server')),
          );
        }
      } catch (e) {
        // Error koneksi atau lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Fungsi untuk menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permintaan Reset Berhasil'),
          content: Text(
              'Permintaan telah diterima. Silakan cek email Anda untuk instruksi lebih lanjut.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
                Navigator.pop(context); // Kembali ke halaman login
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
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Form input email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Masukkan Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Tombol untuk mengirim permintaan reset password
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Kirim Permintaan Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
