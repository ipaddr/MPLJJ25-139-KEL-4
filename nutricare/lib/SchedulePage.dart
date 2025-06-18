import 'package:flutter/material.dart';
import 'edit_schedule_page.dart'; // Import the new edit page

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // Make scheduleData mutable as we'll be editing it directly here
  List<Map<String, String>> scheduleData = [
    {
      "time": "08:45",
      "date": "Today",
      "fullDate": "17 April 2019",
      "task1": "Take 2 pills Aspirin",
      "task2": "Take vitamins"
    },
    {
      "time": "12:15",
      "date": "Today",
      "fullDate": "17 April 2019",
      "task1": "Take 2 pills Aspirin",
      "task2": "Take vitamins"
    },
    {
      "time": "15:45",
      "date": "Today",
      "fullDate": "17 April 2019",
      "task1": "Take 2 pills Aspirin",
      "task2": "Take vitamins"
    },
    {
      "time": "18:00",
      "date": "Today",
      "fullDate": "17 April 2019",
      "task1": "Take 2 pills Aspirin",
      "task2": "Take vitamins"
    },
  ];

  // Function to update an item in the list
  void _updateScheduleItem(int index, Map<String, String> updatedItem) {
    setState(() {
      scheduleData[index] = updatedItem;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jadwal berhasil diperbarui!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 235, 157),
        title: const Text('JADWAL', style: TextStyle(color: Color.fromARGB(255, 13, 13, 13))),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: scheduleData.length,
        itemBuilder: (context, index) {
          final item = scheduleData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Task descriptions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ${item['task1']}", style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text("• ${item['task2']}", style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 10),
                          Text(item['date']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(item['fullDate']!, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    // Right Side: Time and Edit button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item['time']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // Navigate to EditSchedulePage and wait for result
                            final updatedItem = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditSchedulePage(
                                  initialData: Map<String, String>.from(item), // Pass a copy of the item
                                ),
                              ),
                            );

                            // If an updated item is returned, update the list
                            if (updatedItem != null && updatedItem is Map<String, String>) {
                              _updateScheduleItem(index, updatedItem);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}