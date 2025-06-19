import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk mendapatkan peran pengguna
import 'package:nutricare/addschedulepage.dart';
import 'edit_schedule_page.dart'; // Import halaman edit jadwal

class SchedulePage extends StatefulWidget { // Nama kelas diubah menjadi SchedulePage
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState(); // Nama state diubah
}

class _SchedulePageState extends State<SchedulePage> { // Nama state diubah
  String? _userRole; // Untuk menyimpan peran pengguna (misal: 'admin' atau 'user')

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  // Fungsi untuk mendapatkan peran pengguna dari Firestore
  Future<void> _fetchUserRole() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Asumsi koleksi pengguna Anda bernama 'users'
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          _userRole = (userDoc.data() as Map<String, dynamic>)['role'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('JADWAL DISTRIBUSI', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil data dari koleksi 'schedules' di Firestore
        stream: FirebaseFirestore.instance.collection('schedules').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal yang tersedia.'));
          }

          // Data jadwal tersedia
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              String time = data['time'] ?? 'N/A';
              String date = data['date'] ?? 'N/A';
              String fullDate = data['fullDate'] ?? 'N/A';
              String task1 = data['task1'] ?? 'N/A';
              String task2 = data['task2'] ?? 'N/A';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side: Task descriptions
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• $task1", style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text("• $task2", style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 10),
                              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(fullDate, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        // Right Side: Time and Edit button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Tampilkan tombol edit hanya jika pengguna adalah admin
                            if (_userRole == 'admin') // Asumsi peran admin
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditSchedulePage(
                                        initialData: data, // Kirim data saat ini
                                        documentId: document.id, // Kirim ID dokumen
                                      ),
                                    ),
                                  );
                                  // Jika ada hasil dan pembaruan berhasil (result is true)
                                  if (result == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Jadwal berhasil diperbarui!')),
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Tombol FAB untuk menambahkan jadwal baru, hanya untuk admin
      floatingActionButton: _userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSchedulePage()),
                );
                // Jika jadwal baru berhasil ditambahkan, mungkin ingin menampilkan feedback
                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jadwal baru berhasil ditambahkan.')),
                  );
                }
              },
              backgroundColor: const Color.fromARGB(255, 221, 235, 157),
              child: const Icon(Icons.add, color: Colors.black),
            )
          : null, // Jika bukan admin, tidak ada FAB
    );
  }
}
