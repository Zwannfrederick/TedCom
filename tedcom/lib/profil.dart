import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 235, 200),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.red, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // Üstteki Kullanıcı Bilgisi
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 252, 235, 200),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black,
                  width: 2,
                 ),
                ),
              ),

            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 130),
            //color: Color.fromARGB(255, 252, 235, 200),
            child: const Column(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.black54,
                ),
                SizedBox(height: 10),
                Text(
                  '(KULLANICI İSMİ)',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1, height: 1),
          // Bilgi Kartları
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildInfoCard(
                  context,
                  title: 'E-mail:',
                  content: 'ornek@gmail.com',
                ),
                _buildInfoCard(
                  context,
                  title: 'Ana Sektör:',
                  content: 'Savunma Sanayi UZUN SATIR UZUN SATIR UZUN UZUN SATIR SATIR SATIR UZUN SATIR BÖYLE OLUYOR',
                ),
                _buildInfoCard(
                  context,
                  title: 'Telefon Numarası:',
                  content: '(0598) 765 43 21',
                ),
                _buildInfoCard(
                  context,
                  title: 'Doğum Tarihi:',
                  content: '4 Ekim 2004',
                ),
                _buildInfoCard(
                  context,
                  title: 'Doğum Yeri:',
                  content: 'İstanbul',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bilgi Kartı Yapısı
  Widget _buildInfoCard(BuildContext context,
      {required String title, required String content}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Color.fromARGB(255, 252, 235, 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: ' $content',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.black54),
          onPressed: () {
            _showEditDialog(context, title, content);
          },
        ),
      ),
    );
  }

  // Bilgi Düzenleme Diyaloğu
  void _showEditDialog(BuildContext context, String title, String content) {
    TextEditingController _controller = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title Düzenle'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Yeni $title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              // Burada yeni veriyi işleme kısmı yapılabilir
              print('Yeni $title: ${_controller.text}');
              Navigator.pop(context);
            },
            child: Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
