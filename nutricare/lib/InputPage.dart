import 'package:flutter/material.dart';
import 'ConfirmationPage.dart';

class InputPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController ibuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor:const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "INPUT",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 32),
            buildInputField("Nama", namaController),
            buildInputField("NISN", nisnController),
            buildInputField("Tempat Lahir", tempatLahirController),
            buildInputField("Tanggal Lahir", tanggalLahirController),
            buildInputField("Nama ibu kandung", ibuController),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ConfirmationPage(
                            nama: namaController.text,
                            nisn: nisnController.text,
                            tempatLahir: tempatLahirController.text,
                            tanggalLahir: tanggalLahirController.text,
                            ibu: ibuController.text,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                ),
                child: Text("INSERT", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
