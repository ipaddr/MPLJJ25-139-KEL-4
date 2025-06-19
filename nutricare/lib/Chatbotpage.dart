import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk encoding/decoding JSON

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // Menyimpan pesan {role: user/model, text: message}
  bool _isTyping = false; // Untuk indikator mengetik

  // Deklarasi apiKey sebagai string kosong, Canvas akan menyediakannya saat runtime
  final String apiKey = "AIzaSyAwtS8dSoKMvJS1otF9LDMSrc9fEgZf0Ac";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk mengirim pesan ke Gemini API
  Future<void> _sendMessage() async {
    final text = _controller.text;
    _controller.clear();

    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isTyping = true; // Set indikator mengetik saat mengirim
    });

    try {
      // Siapkan chat history untuk dikirim ke API
      List<Map<String, dynamic>> chatHistory = [];
      for (var msg in _messages) {
        chatHistory.add({
          "role": msg["role"],
          "parts": [
            {"text": msg["text"]}
          ]
        });
      }

      final payload = {
        "contents": chatHistory,
      };

      // Buat URL lengkap dengan API Key yang disediakan oleh Canvas
      final String fullApiUrl = "$apiUrl$apiKey";

      final response = await http.post(
        Uri.parse(fullApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['candidates'] != null &&
            result['candidates'].isNotEmpty &&
            result['candidates'][0]['content'] != null &&
            result['candidates'][0]['content']['parts'] != null &&
            result['candidates'][0]['content']['parts'].isNotEmpty) {
          final botText = result['candidates'][0]['content']['parts'][0]['text'];
          setState(() {
            _messages.add({"role": "model", "text": botText});
          });
        } else {
          setState(() {
            _messages.add({"role": "model", "text": "Maaf, saya tidak bisa memahami itu. Coba lagi."});
          });
        }
      } else {
        setState(() {
          _messages.add({"role": "model", "text": "Error: ${response.statusCode} - ${response.body}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "model", "text": "Terjadi kesalahan: $e"});
      });
    } finally {
      setState(() {
        _isTyping = false; // Matikan indikator mengetik setelah respons diterima
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        backgroundColor: const Color.fromARGB(255, 203, 211, 169),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(color: isUser ? Colors.blue[900] : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Chatbot sedang mengetik...", style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan Anda...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onSubmitted: (_) => _sendMessage(), // Mengirim pesan saat Enter ditekan
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
