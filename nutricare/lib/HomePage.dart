import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'InputPage.dart';
import 'ProfilePage.dart';
import 'DataPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  Map<int, double> _scales = {0: 1.0, 1: 1.0};
  Map<int, double> _previousScales = {0: 1.0, 1: 1.0};

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
      InputPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Input'),
          BottomNavigationBarItem(icon: Icon(Icons.data_usage), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.account_circle, size: 40),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hai!", style: TextStyle(fontSize: 16)),
                  Text("Nama users", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),

          // Notifikasi Menu Hari Ini
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 203, 211, 169),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.restaurant_menu, size: 40, color: Colors.black),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Menu Makan Gratis Hari Ini",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 8),
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
          SizedBox(height: 24),

          // Distribusi
          Text("Distribusi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDistribusiItem(index: 0, imagePath: 'assets/images/4sehat.png', title: 'Jadwal Distribusi'),
              _buildDistribusiItem(index: 1, imagePath: 'assets/images/datagizi.jpeg', title: 'Data Penerima Gizi'),
            ],
          ),
          SizedBox(height: 24),

          // Video Edukasi
          Text("Video edukasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(videoLinks.length, (index) {
                final videoUrl = videoLinks[index];
                final videoId = Uri.parse(videoUrl).queryParameters['v'] ?? videoUrl.split('/').last;
                final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
                final title = videoTitles[index];

                return GestureDetector(
                  onTap: () => _launchUrl(videoUrl),
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 10),
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
                              child: Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
