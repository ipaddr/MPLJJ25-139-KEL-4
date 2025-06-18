import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // For new password

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserProfile(); // Load user data when the page initializes
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          setState(() {
            // Update the state if needed after loading data (though not strictly necessary here)
          });
        }
      } catch (e) {
        print('Error loading user profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menyimpan profil...')),
      );

      try {
        // Update Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
        });

        // Update Firebase Authentication (email and password)
        if (_currentUser != null) {
          if (_emailController.text != _currentUser!.email) {
            await _currentUser!.updateEmail(_emailController.text);
          }

          if (_passwordController.text.isNotEmpty) {
            await _currentUser!.updatePassword(_passwordController.text);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil berhasil disimpan!')),
        );
        Navigator.pop(context); // Go back to the profile page
      } on FirebaseAuthException catch (e) {
        String message = 'Gagal menyimpan profil: ${e.message}';
        if (e.code == 'requires-recent-login') {
          message = 'Untuk mengubah email/password, mohon login kembali.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        print('Firebase Auth Error: $e');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: $e')),
        );
        print('Error saving profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Gambar profil (hanya placeholder atau gambar statis)
              CircleAvatar(
                radius: 50,
                // Menggunakan AssetImage karena tidak ada ImagePicker
                backgroundImage: AssetImage('assets/images/pfp.jpeg'),
              ),
              SizedBox(height: 20),

              // Nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Email tidak valid',
              ),
              SizedBox(height: 10),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password Baru (kosongkan jika tidak ingin mengubah)',
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),

              // Tombol simpan
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}