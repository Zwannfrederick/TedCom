import 'package:flutter/material.dart';

class BildirimlerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bildirimler',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 10, // Bildirim kutucuklarının sayısı
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              color: const Color(0xFFFFF1E0), // Açık bej arka plan rengi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.black),
                title: const Text(
                  'Bildirim başlığı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Bildirim açıklaması'),
              ),
            ),
          );
        },
      ),
    );
  }
}
