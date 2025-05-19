import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  String _name = 'Novi Herawati';
  String _email = 'Kelvin@gmail.com';
  String _password = 'admin';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Simpan data (bisa ke database, shared preferences, atau server)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Gambar profil
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : AssetImage('assets/profile.jpg') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.camera_alt, size: 24),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Nama
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nama'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),

              // Email
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value ?? '',
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Email tidak valid',
              ),
              SizedBox(height: 10),

              // Password
              TextFormField(
                decoration: InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
              ),
              SizedBox(height: 30),

              // Tombol simpan
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
