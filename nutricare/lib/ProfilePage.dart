import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto profil, nama, dan email
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/pfp.jpeg'), // Ganti dengan path gambar profil Anda
                ),
                SizedBox(height: 10),
                Text(
                  'Zidan Kelvin',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Kelvin@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Daftar menu
            _buildMenuItem(Icons.edit, 'Edit Profil', () {}),
            _buildMenuItem(Icons.history, 'Riwayat', () {}),
            _buildMenuItem(Icons.question_answer, 'FAQ', () {}),
            _buildMenuItem(Icons.logout, 'Keluar', () {}),
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
}
