import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'ProfilePage.dart';
import 'DataPage.dart';
import 'ChatbotPage.dart'; // Import the new ChatbotPage
// import 'InputPage.dart'; // Jika InputPage akan selalu tersedia, Anda bisa uncomment ini

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Map<int, double> _scales = {0: 1.0, 1: 1.0};
  Map<int, double> _previousScales = {0: 1.0, 1: 1.0};

  // Instance Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> videoLinks = [
    'https://www.youtube.com/watch?v=1bcI39ssaaw&t=2s',
    'https://www.youtube.com/watch?v=z88lgOdF0-M&t=3s',
    'https://www.youtube.com/watch?v=A6Da2SdfTO8',
    'https://www.youtube.com/shorts/veE_Zbq8eiM',
  ];

  final List<String> videoTitles = [
    'Edukasi Gizi 1',
    'Edukasi Gizi 2',
    'Pentingnya Nutrisi',
    'Tips Makan Sehat',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(), // Gunakan konten khusus beranda
      // InputPage(), // Tambahkan kembali jika InputPage diperlukan di bottom nav untuk guru/admin
      DataPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 246, 233),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          // BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Input'), // Tambahkan kembali jika InputPage diperlukan
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    // Pastikan user tidak null sebelum mencoba mengambil UID
    if (_auth.currentUser == null) {
      // Handle case where user is not logged in (shouldn't happen if login check is correct)
      return const Center(child: Text("User not logged in. Please log in again."));
    }

    return FutureBuilder<DocumentSnapshot>(
      // Mengambil data user dari Firestore berdasarkan UID user yang sedang login
      future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          // Menampilkan error jika pengambilan data gagal
          return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
        }

        // Menampilkan pesan jika dokumen tidak ditemukan (misal: user baru tanpa data profil di Firestore)
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
          return const Center(child: Text("Data profil tidak ditemukan."));
        }
        
        // Memastikan data ada sebelum diakses dan koneksi sudah selesai
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          // Mengambil data dari dokumen
          Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;

          // Mengambil nama user, default ke "Nama users" jika tidak ada
          String userName = data?['name'] ?? "Nama users";
          // String userRole = data?['role'] ?? "N/A"; // Jika ingin menampilkan role juga

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(Icons.account_circle, size: 40),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Hai!", style: TextStyle(fontSize: 16)),
                        // Menampilkan nama user yang diambil dari Firestore
                        Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        // Text("Role: $userRole", style: TextStyle(fontSize: 12, color: Colors.grey[600])), // Contoh menampilkan role
                      ],
                    ),
                    const Spacer(), // Pushes the next widget to the right
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, size: 28), // Chat icon
                      onPressed: () {
                        // Navigasi ke halaman ChatbotPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatbotPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Notifikasi Menu Hari Ini
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 203, 211, 169),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.restaurant_menu, size: 40, color: Colors.black),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Menu Makan Gratis Hari Ini",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 8),
                            Text(
                              "• Nasi Putih\n• Ayam Bakar\n• Sayur Bayam\n• Buah Pisang\n• Air Mineral",
                              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Distribusi
                const Text("Distribusi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDistribusiItem(index: 0, imagePath: 'assets/images/4sehat.png', title: 'Jadwal Distribusi'),
                    _buildDistribusiItem(index: 1, imagePath: 'assets/images/datagizi.jpeg', title: 'Data Penerima Gizi'),
                  ],
                ),
                const SizedBox(height: 24),

                // Video Edukasi
                const Text("Video edukasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(videoLinks.length, (index) {
                      final videoUrl = videoLinks[index];
                      // videoId tidak digunakan, bisa dihapus
                      final videoId = Uri.parse(videoUrl).queryParameters['v'] ?? videoUrl.split('/').last; 
                      final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
                      final title = videoTitles[index];

                      return GestureDetector(
                        onTap: () => _launchUrl(videoUrl),
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  thumbnailUrl,
                                  width: 150,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey,
                                    width: 150,
                                    height: 100,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }

        // Menampilkan CircularProgressIndicator saat data sedang diambil
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildDistribusiItem({
    required int index,
    required String imagePath,
    required String title,
    Color boxColor = Colors.white,
  }) {
    return GestureDetector(
      onScaleStart: (details) {
        _previousScales[index] = _scales[index] ?? 1.0;
      },
      onScaleUpdate: (details) {
        setState(() {
          double newScale = (_previousScales[index]! * details.scale).clamp(1.0, 3.0);
          _scales[index] = newScale;
        });
      },
      onScaleEnd: (details) {
        _previousScales[index] = 1.0;
      },
      child: Transform.scale(
        scale: _scales[index] ?? 1.0,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [ // Perbaikan di sini: menghapus 'box' yang berlebihan
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  width: 200,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
