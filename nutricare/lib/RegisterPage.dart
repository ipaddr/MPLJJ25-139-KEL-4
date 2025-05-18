import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/Nutricare.png', // Ganti dengan path logo kamu
                width: 250,
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Tampilkan notifikasi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pendaftaran berhasil!'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Kembali ke halaman login setelah delay sedikit agar snackBar muncul dulu
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
