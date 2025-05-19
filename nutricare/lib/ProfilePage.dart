import 'package:flutter/material.dart';
import 'EditProfilePage.dart';
import 'FaqPage.dart';
import 'LoginPage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto profil, nama, email
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/pfp.jpeg'), // Ganti dengan path gambar
                ),
                SizedBox(height: 10),
                Text(
                  'Zidan Kelvin',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'kelcin@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 20),

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
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Contoh logout sederhana: kembali ke halaman login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
