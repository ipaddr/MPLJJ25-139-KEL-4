import 'package:flutter/material.dart';

class EditSchedulePage extends StatefulWidget {
  final Map<String, String> initialData;

  const EditSchedulePage({Key? key, required this.initialData}) : super(key: key);

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  late TextEditingController _timeController;
  late TextEditingController _dateController; // For "Today"
  late TextEditingController _fullDateController; // For "17 April 2019"
  late TextEditingController _task1Controller;
  late TextEditingController _task2Controller;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the initial data received
    _timeController = TextEditingController(text: widget.initialData['time']);
    _dateController = TextEditingController(text: widget.initialData['date']);
    _fullDateController = TextEditingController(text: widget.initialData['fullDate']);
    _task1Controller = TextEditingController(text: widget.initialData['task1']);
    _task2Controller = TextEditingController(text: widget.initialData['task2']);
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Create an updated map with the new values
      final Map<String, String> updatedData = {
        'time': _timeController.text,
        'date': _dateController.text,
        'fullDate': _fullDateController.text,
        'task1': _task1Controller.text,
        'task2': _task2Controller.text,
      };
      // Pop the current page and return the updated data
      Navigator.pop(context, updatedData);
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
                  validator: (value) => value!.isEmpty ? 'Tugas 1 tidak boleh kosong' : null),
              _buildTextFormField(
                  controller: _task2Controller, label: 'Menu 2',
                  validator: (value) => value!.isEmpty ? 'Tugas 2 tidak boleh kosong' : null),
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