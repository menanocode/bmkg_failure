import 'package:flutter/material.dart';
import 'earthquake_screen.dart';
import 'weather_screen.dart';
import 'news_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  HomeScreen({required this.userEmail, required this.userPassword});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Menyimpan indeks halaman yang aktif
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      EarthquakeScreen(),
      WeatherScreen(),
      NewsScreen(),
      AboutScreen(
          userEmail: widget.userEmail, userPassword: widget.userPassword),
    ];
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Kembali ke login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mulyono Info Indonesia'),
      ),
      body: _pages[_currentIndex], // Menampilkan halaman berdasarkan index
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Ganti sesuai jalur logo Anda
                    height: 80, // Sesuaikan tinggi gambar
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Gempa'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context); // Menutup drawer setelah memilih
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Cuaca'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Berita'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Tentang'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout, // Tombol logout
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menentukan halaman yang aktif
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // Mengubah halaman berdasarkan item yang dipilih
          });
        },
        backgroundColor: Colors.blueGrey, // Mengubah warna footer
        selectedItemColor:
            Colors.black87, // Warna ikon dan label item yang dipilih
        unselectedItemColor:
            Colors.black45, // Warna ikon dan label item yang tidak dipilih
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, color: Colors.red), // Ikon gempa
            label: 'Gempa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud, color: Colors.orange), // Ikon cuaca
            label: 'Cuaca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article, color: Colors.green), // Ikon berita
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.blue), // Ikon tentang
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}
