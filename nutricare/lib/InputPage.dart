import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Make sure to add firebase_auth to your pubspec.yaml

import 'EditProfilePage.dart'; // Tetap import ini meskipun tidak digunakan di InputPage
import 'FaqPage.dart'; // Tetap import ini meskipun tidak digunakan di InputPage
import 'LoginPage.dart'; // Tetap import ini meskipun tidak digunakan di InputPage
import 'ConfirmationPage.dart'; // Import ConfirmationPage

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController ibuController = TextEditingController();

  final TextEditingController tanggalLahirController = TextEditingController();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namaController.dispose();
    nisnController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    ibuController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 221, 235, 157),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        tanggalLahirController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Helper untuk menghitung usia dari tanggal lahir (mirip dengan di model)
  int _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0;

    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _saveRecipientData() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menyimpan data penerima...')),
      );

      try {
        // Simpan data ke Firestore
        await FirebaseFirestore.instance.collection('recipients').add({
          'nama': namaController.text,
          'nisn': nisnController.text,
          'tempatLahir': tempatLahirController.text,
          'tanggalLahir': tanggalLahirController.text, // Simpan sebagai String
          'namaIbuKandung': ibuController.text,
          'createdAt': Timestamp.now(),
        });

        // Hitung usia untuk diteruskan ke ConfirmationPage
        int usiaPenerima = _calculateAge(_selectedDate);

        // Bersihkan field setelah berhasil disimpan (opsional, tergantung alur Anda)
        // Jika ingin membersihkan, lakukan ini SEBELUM navigasi ke ConfirmationPage
        String tempNama = namaController.text;
        String tempNisn = nisnController.text;
        String tempTempatLahir = tempatLahirController.text;
        String tempTanggalLahir = tanggalLahirController.text;
        String tempIbu = ibuController.text;

        namaController.clear();
        nisnController.clear();
        tempatLahirController.clear();
        tanggalLahirController.clear();
        ibuController.clear();
        setState(() {
          _selectedDate = null; // Reset tanggal yang dipilih
        });

        // Navigasi ke ConfirmationPage dengan membawa data yang baru saja diinput
        Navigator.pushReplacement( // Menggunakan pushReplacement agar tidak bisa kembali ke halaman input dengan tombol back
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationPage(
              nama: tempNama,
              nisn: tempNisn,
              tempatLahir: tempTempatLahir,
              tanggalLahir: tempTanggalLahir,
              namaIbuKandung: tempIbu,
              usia: usiaPenerima, // Teruskan usia yang dihitung
            ),
          ),
        );
      } catch (e) {
        print('Error saving recipient data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "INPUT",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              buildInputField("Nama", namaController),
              // NISN Field with validation
              buildInputField("NISN", nisnController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NISN tidak boleh kosong';
                    }
                    // Validasi: NISN harus memiliki minimal 10 karakter (lebih dari 9 angka)
                    if (value.length < 10) {
                      return 'NISN harus memiliki minimal 10 angka';
                    }
                    return null;
                  }),
              // Tempat Lahir field tanpa tombol auto-fill geolokasi
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 100, child: Text("Tempat Lahir")),
                    Expanded(
                      child: TextFormField(
                        controller: tempatLahirController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: UnderlineInputBorder(),
                          // SuffixIcon yang sebelumnya untuk geolokasi telah dihapus
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tempat lahir tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 100, child: Text("Tanggal Lahir")),
                    Expanded(
                      child: TextFormField(
                        controller: tanggalLahirController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                          border: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal lahir tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              buildInputField("Nama ibu kandung", ibuController),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveRecipientData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                  ),
                  child: const Text("INSERT", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                border: UnderlineInputBorder(),
              ),
              validator: validator ?? (value) { // Gunakan validator yang disediakan atau default
                if (value == null || value.isEmpty) {
                  return '$label tidak boleh kosong';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
