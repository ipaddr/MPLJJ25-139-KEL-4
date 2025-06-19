import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fullDateController = TextEditingController();
  final TextEditingController _task1Controller = TextEditingController();
  final TextEditingController _task2Controller = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    _fullDateController.dispose();
    _task1Controller.dispose();
    _task2Controller.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan jadwal baru ke Firestore
  Future<void> _saveNewSchedule() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menyimpan jadwal baru...')),
      );

      try {
        final Map<String, dynamic> newScheduleData = {
          'time': _timeController.text,
          'date': _dateController.text,
          'fullDate': _fullDateController.text,
          'task1': _task1Controller.text,
          'task2': _task2Controller.text,
          'createdAt': Timestamp.now(), // Tambahkan timestamp pembuatan
          'updatedAt': Timestamp.now(), // Tambahkan timestamp pembaruan awal
        };

        await FirebaseFirestore.instance.collection('schedules').add(newScheduleData);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal baru berhasil ditambahkan!')),
        );

        // Kembali ke halaman sebelumnya (ScheduleListPage)
        Navigator.pop(context, true); // Mengirim true untuk menunjukkan penambahan berhasil
      } catch (e) {
        print('Error adding new schedule: $e');
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan jadwal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('Tambah Jadwal Baru', style: TextStyle(color: Colors.black)),
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
                  "TAMBAH JADWAL",
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
                  onPressed: _saveNewSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tambah Jadwal', style: TextStyle(color: Colors.black)),
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
