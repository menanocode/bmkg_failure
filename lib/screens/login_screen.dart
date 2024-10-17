import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import halaman Home

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // Username dan password yang benar (hardcoded)
  final String correctUsername = 'user@example.com';
  final String correctPassword = 'password123';

  void _login() {
    // Ambil email dan password dari form
    String email = _emailController.text;
    String password = _passwordController.text;

    // Validasi email dan password
    if (email == correctUsername && password == correctPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login sukses!')),
      );
      // Arahkan ke halaman Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Panggil HomeScreen setelah login sukses
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal, periksa email dan password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo di bagian atas
              Image.asset(
                'assets/images/logo.png', // Ganti sesuai jalur logo Anda
                height: 100, // Sesuaikan tinggi gambar
              ),
              SizedBox(height: 16.0),

              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login(); // Panggil fungsi login
                  }
                },
                child: Text('Login'),
              ),

              // Opsi "Forgot Password"
              TextButton(
                onPressed: () {
                  // Fungsi forgot password dapat ditambahkan di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Forgot password clicked!')),
                  );
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
