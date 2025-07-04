import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Make sure to add firebase_auth to your pubspec.yaml

import 'EditProfilePage.dart';
import 'FaqPage.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser; // To hold the current authenticated user

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // Get the current user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _currentUser == null
            ? const Center(child: Text('Tidak ada pengguna yang masuk.')) // Handle case no user is logged in
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUser!.uid) // Use the current user's UID to fetch their document
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('Data profil tidak ditemukan.'));
                  }

                  // Data exists, extract it
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  String name = userData['name'] ?? 'Nama Tidak Ditemukan';
                  String email = userData['email'] ?? 'Email Tidak Ditemukan';
                  String role = userData['role'] ?? 'Peran Tidak Ditemukan'; // You can use role if you want to display it

                  return Column(
                    children: [
                      // Foto profil, nama, email
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: const AssetImage(
                                'assets/images/pfp.jpeg'), // You can make this dynamic too if user uploads profile pic
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          // Optionally display role
                          Text(
                            'Peran: $role',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Menu
                      _buildMenuItem(Icons.settings, 'Edit Profil', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfilePage()),
                        );
                      }),

                      _buildMenuItem(Icons.question_answer, 'FAQ', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FaqPage()),
                        );
                      }),
                      _buildMenuItem(Icons.logout, 'Keluar', () {
                        _showLogoutConfirmation(context);
                      }),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog konfirmasi
              _logout(context); // Panggil fungsi logout
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
    // Gunakan pushAndRemoveUntil untuk menghapus semua rute sebelumnya dan kembali ke LoginPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Pastikan LoginPage sudah diimpor dengan benar
      (Route<dynamic> route) => false, // Ini memastikan semua rute di tumpukan dihapus
    );
  }
}
