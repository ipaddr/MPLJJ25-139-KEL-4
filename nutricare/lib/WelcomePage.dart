import 'package:flutter/material.dart';
import 'LoginPage.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 246, 233),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Bagian Atas: Teks dan tombol, rata kiri
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutricare',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Aplikasi ini merupakan aplikasi mobile\nuntuk pendamping gizi dan Distribusi',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                        foregroundColor: Colors.black,
                        elevation: 4,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Mulai'),
                    ),
                  ),
                ],
              ),

              // Spacer agar gambar berada di tengah layar
              Spacer(),

              // Gambar ditengah layar
              Center(
                child: Container(
                  width: 500,
                  height: 250,
                  child: Image.asset(
                    'assets/images/Nutrizionista.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Spacer bawah jika mau beri jarak
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
