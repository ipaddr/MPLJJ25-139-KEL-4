import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 246, 233),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 246, 233),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Placeholder gambar atas
            Container(
              width: 250,
              height: 150,
              child: Image.asset(
                'assets/images/Nutricare.png', // Ganti dengan path logo kamu
                fit: BoxFit.contain, // Biar logonya muat
              ),
            ),

            SizedBox(height: 16),
            Text(
              'LOGIN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // aksi login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 235, 157),
                foregroundColor: Colors.black,
              ),
              child: Text('Masuk'),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                // aksi ke halaman daftar
              },
              child: Text(
                'Tidak mempunyai akun ? Daftar',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class XCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
