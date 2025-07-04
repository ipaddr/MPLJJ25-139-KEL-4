import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSchedulePage extends StatefulWidget {
  // initialData berisi nilai-nilai saat ini untuk diisi di form
  final Map<String, dynamic> initialData;
  // documentId diperlukan untuk mengetahui dokumen mana yang akan diupdate di Firestore
  final String documentId;

  const EditSchedulePage({
    Key? key,
    required this.initialData,
    required this.documentId, // <--- Pastikan parameter ini ada dan diperlukan
  }) : super(key: key);

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  late TextEditingController _timeController;
  late TextEditingController _dateController; // For "Today" / "Tomorrow" etc.
  late TextEditingController _fullDateController; // For "17 April 2019"
  late TextEditingController _task1Controller;
  late TextEditingController _task2Controller;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the initial data received
    _timeController = TextEditingController(text: widget.initialData['time'] ?? '');
    _dateController = TextEditingController(text: widget.initialData['date'] ?? '');
    _fullDateController = TextEditingController(text: widget.initialData['fullDate'] ?? '');
    _task1Controller = TextEditingController(text: widget.initialData['task1'] ?? '');
    _task2Controller = TextEditingController(text: widget.initialData['task2'] ?? '');
  }

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    _fullDateController.dispose();
    _task1Controller.dispose();
    _task2Controller.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan perubahan ke Firestore
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menyimpan perubahan jadwal...')),
      );

      try {
        // Buat map dengan nilai-nilai yang diperbarui
        final Map<String, dynamic> updatedData = {
          'time': _timeController.text,
          'date': _dateController.text,
          'fullDate': _fullDateController.text,
          'task1': _task1Controller.text,
          'task2': _task2Controller.text,
          'updatedAt': Timestamp.now(), // Tambahkan timestamp pembaruan
        };

        // Perbarui dokumen di koleksi 'schedules' di Firestore
        await FirebaseFirestore.instance
            .collection('schedules')
            .doc(widget.documentId) // Gunakan documentId yang diterima
            .update(updatedData);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil diperbarui!')),
        );

        // Kembali ke halaman sebelumnya (SchedulePage)
        Navigator.pop(context, true); // Mengirim true untuk menunjukkan pembaruan berhasil
      } catch (e) {
        print('Error updating schedule data: $e');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui jadwal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('Edit Jadwal', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "EDIT JADWAL",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextFormField(
                  controller: _timeController, label: 'Waktu (contoh: 08:45)',
                  validator: (value) => value!.isEmpty ? 'Waktu tidak boleh kosong' : null),
              _buildTextFormField(
                  controller: _dateController, label: 'Hari (contoh: Today)',
                  validator: (value) => value!.isEmpty ? 'Hari tidak boleh kosong' : null),
              _buildTextFormField(
                  controller: _fullDateController, label: 'Tanggal Lengkap (contoh: 17 April 2019)',
                  validator: (value) => value!.isEmpty ? 'Tanggal lengkap tidak boleh kosong' : null),
              _buildTextFormField(
                  controller: _task1Controller, label: 'Menu 1',
                  validator: (value) => value!.isEmpty ? 'Menu 1 tidak boleh kosong' : null),
              _buildTextFormField(
                  controller: _task2Controller, label: 'Menu 2',
                  validator: (value) => value!.isEmpty ? 'Menu 2 tidak boleh kosong' : null),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
      ),
    );
  }
}
