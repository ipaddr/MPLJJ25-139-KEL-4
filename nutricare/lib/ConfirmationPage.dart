import 'package:flutter/material.dart';
import 'package:nutricare/HomePage.dart';
import 'package:nutricare/admin_homepage.dart';
import 'InputPage.dart'; // Import InputPage untuk navigasi kembali
import 'PenerimaGiziPage.dart'; // Import PenerimaGiziPage

class ConfirmationPage extends StatelessWidget {
  final String nama;
  final String nisn;
  final String tempatLahir;
  final String tanggalLahir;
  final String namaIbuKandung;
  final int usia; // Tambahkan usia untuk ditampilkan

  ConfirmationPage({
    Key? key,
    required this.nama,
    required this.nisn,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.namaIbuKandung,
    required this.usia, // Usia akan diterima dari InputPage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Berhasil!'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Pendaftaran Penerima Gizi Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Informasi Detail Penerima
            _buildDetailRow('Nama:', nama),
            _buildDetailRow('NISN:', nisn),
            _buildDetailRow('Tempat, Tanggal Lahir:', '$tempatLahir, $tanggalLahir'),
            _buildDetailRow('Usia:', '$usia tahun'),
            _buildDetailRow('Nama Ibu Kandung:', namaIbuKandung),
            const SizedBox(height: 40),
            // Tombol untuk aksi selanjutnya
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHomepage()),
                    (Route<dynamic> route) => false, // Hapus semua route sebelumnya
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black, // Warna teks tombol
                  side: const BorderSide(
                      color: Color.fromARGB(255, 221, 235, 157), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Kembali ke Beranda',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Sesuaikan lebar label
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}