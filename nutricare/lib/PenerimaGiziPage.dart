import 'package:flutter/material.dart';

// Model data penerima gizi
class PenerimaGizi {
  final String nama;
  final int usia;
  final String statusGizi;
  final String alamat;

  PenerimaGizi({
    required this.nama,
    required this.usia,
    required this.statusGizi,
    required this.alamat,
  });
}

class PenerimaGiziPage extends StatelessWidget {
  PenerimaGiziPage({Key? key}) : super(key: key);

  // List data lengkap tiap penerima gizi
  final List<PenerimaGizi> penerimaList =  [
    PenerimaGizi(
        nama: "Ani",
        usia: 5,
        statusGizi: "Cukup",
        alamat: "Desa Sehat No. 1"),
    PenerimaGizi(
        nama: "Budi",
        usia: 6,
        statusGizi: "Kurang",
        alamat: "Desa Makmur No. 2"),
    PenerimaGizi(
        nama: "Citra",
        usia: 4,
        statusGizi: "Baik",
        alamat: "Desa Harapan No. 3"),
    PenerimaGizi(
        nama: "Dedi",
        usia: 5,
        statusGizi: "Cukup",
        alamat: "Desa Mandiri No. 4"),
    PenerimaGizi(
        nama: "Eka",
        usia: 7,
        statusGizi: "Baik",
        alamat: "Desa Sejahtera No. 5"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('Daftar Penerima Gizi'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: penerimaList.length,
        itemBuilder: (context, index) {
          final penerima = penerimaList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kotak gambar profil
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
                // Informasi di samping gambar
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
                        Text("Usia: ${penerima.usia} tahun"),
                        Text("Status Gizi: ${penerima.statusGizi}"),
                        Text("Alamat: ${penerima.alamat}"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
