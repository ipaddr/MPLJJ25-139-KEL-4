import 'package:flutter/material.dart';
import 'package:nutricare/admin_homepage.dart';
import 'RegisterPage.dart';
import 'HomePage.dart'; // Ini akan menjadi HomePage umum atau halaman khusus guru
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'AdminDashboardPage.dart'; // Anda mungkin perlu halaman khusus admin nanti

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // Ubah ke emailController
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi login umum yang akan memverifikasi peran
  Future<void> _login(BuildContext context, String expectedRole) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), // Gunakan emailController
        password: passwordController.text.trim(),
      );

      // Jika login berhasil, ambil data user dari Firestore untuk menentukan peran
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        String? actualRole = userDoc['role']; // Ambil peran dari Firestore

        if (actualRole == expectedRole) {
          // Peran cocok, login berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login berhasil sebagai $actualRole!")),
          );

          // TODO: Nanti, navigasi ke halaman yang berbeda sesuai peran
          if (actualRole == 'admin') {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboardPage())); // Navigasi ke halaman admin
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomepage())); // Sementara ke HomePage dulu
          } else { // Jika 'guru'
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); // Navigasi ke HomePage (untuk guru)
          }

        } else {
          // Peran tidak cocok dengan yang dipilih
          await _auth.signOut(); // Logout user yang salah peran
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Akses ditolak: Anda mencoba login sebagai $expectedRole, tetapi akun Anda adalah $actualRole.")),
          );
        }
      } else {
        // Data user tidak ditemukan di Firestore, mungkin baru daftar tapi data peran belum terekam
        await _auth.signOut(); // Logout user yang tidak lengkap datanya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login berhasil, tetapi data peran tidak ditemukan. Mohon coba lagi atau hubungi admin.")),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Tidak ada user dengan email ini.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      }
      else {
        message = 'Terjadi kesalahan: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan tak terduga: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hapus leading BackButton jika LoginPage adalah entry point aplikasi
        // leading: BackButton(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Logo Nutricare
            Container(
              width: 250,
              height: 150,
              child: Image.asset(
                'assets/images/Nutricare.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextField(
              controller: emailController, // Ubah ke emailController
              decoration: InputDecoration(
                labelText: 'Email', // Ubah jadi Email
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress, // Tambahkan ini
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            // Tombol untuk Login Sebagai Guru
            ElevatedButton(
              onPressed: () => _login(context, 'guru'), // Panggil dengan peran 'guru'
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                foregroundColor: Colors.black,
              ),
              child: Text('Masuk Sebagai Guru'),
            ),
            SizedBox(height: 16), // Jarak antar tombol
            // Tombol untuk Login Sebagai Admin
            ElevatedButton(
              onPressed: () => _login(context, 'admin'), // Panggil dengan peran 'admin'
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 160, 200, 120), // Warna berbeda untuk admin
                foregroundColor: Colors.black,
              ),
              child: Text('Masuk Sebagai Admin'),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Belum punya akun? Daftar di sini.', // Ubah teks
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}