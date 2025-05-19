import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  final List<FaqSection> sections = [
    FaqSection(
      title: 'Informasi umum',
      items: [
        FaqItem(
          question: 'Apakah Nutricare itu?',
          answer:
              'Aplikasi mobile yang digunakan untuk mencatat distribusi bantuan makanan gratis serta menyediakan video edukasi seputar pentingnya gizi dan pola makan sehat.',
        ),
        FaqItem(
          question: 'Apakah Nutricare tepat untuk sekolah?',
          answer: 'Ya, Nutricare sangat cocok untuk sekolah karena membantu mencatat dan mendistribusikan makanan bergizi secara efisien.',
        ),
        FaqItem(
          question: 'Mengapa ada video edukasi?',
          answer: 'Video edukasi ditujukan untuk meningkatkan kesadaran tentang pentingnya pola makan sehat sejak dini.',
        ),
      ],
    ),
    FaqSection(
      title: 'Mengenai Distribusi',
      items: [
        FaqItem(
          question: 'Apakah Nutricare tepat untuk sekolah?',
          answer: 'Distribusi di sekolah memungkinkan anak-anak mendapatkan asupan gizi yang baik setiap hari.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FAQ'), centerTitle: true),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                ...section.items.map((item) => _buildFaqTile(item)).toList(),
                Divider(thickness: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqTile(FaqItem item) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Text(
            item.answer,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

class FaqSection {
  final String title;
  final List<FaqItem> items;

  FaqSection({required this.title, required this.items});
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
