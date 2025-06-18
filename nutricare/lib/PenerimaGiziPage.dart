import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_penerima_gizi_page.dart'; // Import halaman edit yang baru

// --- Model data penerima gizi (disesuaikan dengan Firestore) ---
class PenerimaGizi {
  final String id; // Tambahkan ID dokumen Firestore
  final String nama;
  final String nisn;
  final String tempatLahir;
  final String tanggalLahir; // Tetap sebagai String dari Firestore
  final String namaIbuKandung;

  PenerimaGizi({
    required this.id,
    required this.nama,
    required this.nisn,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.namaIbuKandung,
  });

  // Factory constructor untuk membuat objek PenerimaGizi dari DocumentSnapshot
  factory PenerimaGizi.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PenerimaGizi(
      id: doc.id,
      nama: data['nama'] ?? 'Tidak ada nama',
      nisn: data['nisn'] ?? 'Tidak ada NISN',
      tempatLahir: data['tempatLahir'] ?? 'Tidak ada tempat lahir',
      tanggalLahir: data['tanggalLahir'] ?? 'Tidak ada tanggal lahir',
      namaIbuKandung: data['namaIbuKandung'] ?? 'Tidak ada nama ibu',
    );
  }

  // Helper untuk menghitung usia dari tanggal lahir
  int calculateAge() {
    if (tanggalLahir.isEmpty) return 0;

    try {
      List<String> parts = tanggalLahir.split('-');
      if (parts.length != 3) {
        // Coba format YYYY-MM-DD jika "DD-MM-YYYY" gagal
        parts = tanggalLahir.split('-');
        if (parts.length != 3) {
          throw FormatException("Format tanggal salah: $tanggalLahir");
        }
      }
      // Pastikan urutan parsing sesuai dengan format yang diharapkan (DD-MM-YYYY)
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      DateTime birthDate = DateTime(year, month, day);
      DateTime today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print("Error calculating age for $tanggalLahir: $e");
      return 0;
    }
  }
}

// --- PenerimaGiziPage sekarang adalah StatefulWidget untuk StreamBuilder ---
class PenerimaGiziPage extends StatefulWidget {
  const PenerimaGiziPage({Key? key}) : super(key: key);

  @override
  State<PenerimaGiziPage> createState() => _PenerimaGiziPageState();
}

class _PenerimaGiziPageState extends State<PenerimaGiziPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('Daftar Penerima Gizi'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada data penerima gizi.'));
          }

          final List<PenerimaGizi> penerimaList = snapshot.data!.docs.map((doc) {
            return PenerimaGizi.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: penerimaList.length,
            itemBuilder: (context, index) {
              final penerima = penerimaList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 222, 220, 220),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.person, size: 40, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 220, 220),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(penerima.nama,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("NISN: ${penerima.nisn}"),
                            Text("Tempat, Tgl Lahir: ${penerima.tempatLahir}, ${penerima.tanggalLahir}"),
                            Text("Usia: ${penerima.calculateAge()} tahun"),
                            Text("Nama Ibu Kandung: ${penerima.namaIbuKandung}"),
                          ],
                        ),
                      ),
                    ),
                    // Tombol Edit
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Navigasi ke halaman edit dengan meneruskan data penerima
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPenerimaGiziPage(
                              penerima: penerima, // Meneruskan objek penerima lengkap
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}