import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final String nama;
  final String nisn;
  final String tempatLahir;
  final String tanggalLahir;
  final String ibu;

  ConfirmationPage({
    required this.nama,
    required this.nisn,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.ibu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255,160, 200, 120),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: Icon(Icons.check, size: 40), 
            ),
            SizedBox(height: 40),
            Container(
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 235, 157),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow("Nama", nama),
                  infoRow("NISN", nisn),
                  infoRow("Tempat Lahir", tempatLahir),
                  infoRow("Tanggal Lahir", tanggalLahir),
                  infoRow("Nama ibu kandung", ibu),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label)),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
