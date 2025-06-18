import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk menyimpan data peran
import 'package:nutricare/LoginPage.dart'; // Pastikan path ini benar

// import 'HomePage.dart'; // Hapus atau biarkan jika tidak digunakan setelah register

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // Controller untuk nama
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    try {
      // Membuat user baru dengan email dan password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Setelah berhasil mendaftar, simpan data tambahan user (nama dan role) ke Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'role': 'guru', // Default role untuk pengguna baru adalah 'guru'
        'name': _nameController.text.trim(), // <<<--- SIMPAN NAMA DARI _nameController
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pendaftaran berhasil!")),
      );

      // Navigasi kembali ke LoginPage setelah pendaftaran
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'Kata sandi terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email ini sudah terdaftar.';
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid.';
      } else {
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
            // Input untuk Nama
            TextField(
              controller: _nameController, // <<<--- HUBUNGKAN DENGAN CONTROLLER NAMA
              decoration: InputDecoration(
                labelText: 'Nama Lengkap', // Label untuk input nama
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16), // Spasi antar field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose(); // <<<--- PENTING: DISPOSE JUGA _nameController
    super.dispose();
  }
}