import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PenerimaGiziPage.dart'; // Import model PenerimaGizi

class EditPenerimaGiziPage extends StatefulWidget {
  final PenerimaGizi penerima; // Menerima objek PenerimaGizi yang akan diedit

  const EditPenerimaGiziPage({Key? key, required this.penerima}) : super(key: key);

  @override
  _EditPenerimaGiziPageState createState() => _EditPenerimaGiziPageState();
}

class _EditPenerimaGiziPageState extends State<EditPenerimaGiziPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController ibuController = TextEditingController();

  final TextEditingController tanggalLahirController = TextEditingController();
  DateTime? _selectedDate; // Untuk menyimpan objek DateTime yang dipilih

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data penerima yang ada
    namaController.text = widget.penerima.nama;
    nisnController.text = widget.penerima.nisn;
    tempatLahirController.text = widget.penerima.tempatLahir;
    tanggalLahirController.text = widget.penerima.tanggalLahir;
    ibuController.text = widget.penerima.namaIbuKandung;

    // Parse tanggal lahir string ke DateTime untuk date picker
    if (widget.penerima.tanggalLahir.isNotEmpty) {
      try {
        List<String> parts = widget.penerima.tanggalLahir.split('-');
        if (parts.length == 3) {
          _selectedDate = DateTime(
            int.parse(parts[2]), // Year
            int.parse(parts[1]), // Month
            int.parse(parts[0]), // Day
          );
        }
      } catch (e) {
        print("Error parsing initial date: ${e}");
      }
    }
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

  // Fungsi untuk menampilkan DatePicker (sama seperti di InputPage)
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
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 221, 235, 157),
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

  // Fungsi untuk memperbarui data di Firestore
  Future<void> _updateRecipientData() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Memperbarui data penerima...')),
      );

      try {
        // Memperbarui dokumen di Firestore berdasarkan ID
        await FirebaseFirestore.instance
            .collection('recipients')
            .doc(widget.penerima.id) // Menggunakan ID dokumen dari objek penerima
            .update({
          'nama': namaController.text,
          'nisn': nisnController.text,
          'tempatLahir': tempatLahirController.text,
          'tanggalLahir': tanggalLahirController.text,
          'namaIbuKandung': ibuController.text,
          // createdAt tidak perlu diupdate
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data penerima berhasil diperbarui!')),
        );

        // Kembali ke halaman daftar penerima gizi setelah berhasil update
        Navigator.pop(context);

      } catch (e) {
        print('Error updating recipient data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
        title: const Text('Edit Data Penerima Gizi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "EDIT", // Ganti judul halaman
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 32),
              buildInputField("Nama", namaController),
              buildInputField("NISN", nisnController, keyboardType: TextInputType.number),
              buildInputField("Tempat Lahir", tempatLahirController),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    SizedBox(width: 100, child: Text("Tanggal Lahir")),
                    Expanded(
                      child: TextFormField(
                        controller: tanggalLahirController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
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
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _updateRecipientData, // Panggil fungsi update
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                  ),
                  child: Text("UPDATE", style: TextStyle(color: Colors.black)), // Ubah teks tombol
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                border: UnderlineInputBorder(),
              ),
              validator: (value) {
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