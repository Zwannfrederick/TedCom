import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 235, 200),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.red, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Üstteki Kullanıcı Bilgisi
          Container(
            //color: const Color.fromARGB(255, 252, 235, 200),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 252, 235, 200),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
            
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 170),
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.black54,
                ),
                const SizedBox(height: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Yükleniyor animasyonu
                    }
                    if (snapshot.hasError) {
                      return const Text('Bir hata oluştu');
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text('Kullanıcı bilgisi bulunamadı');
                    }

                    // Kullanıcı ismini alıyoruz
                    String userName = snapshot.data!.get('name') ?? 'Bilinmiyor';

                    return Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1),
          // Bilgi Kartları
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(
                  context,
                  title: 'E-mail:',
                  content: FirebaseAuth.instance.currentUser!.email ?? 'Bilinmiyor',
                ),
                _buildInfoCard(
                  context,
                  title: 'Ana Sektör:',
                  content: 'Savunma Sanayi UZUN SATIR UZUN SATIR UZUN SATIR UZUN SATIR',
                ),

                // BAŞLANGIÇTA BU BİLGİLER BOŞ OLACAK KAYIT OLUNDUKTAN SONRA KULLANICIDAN OPSİYONEL OLARAK ALINARAK VERİ TABANINA KAYDEDİLECEK??
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

  Future<DocumentSnapshot> _getUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color.fromARGB(255, 252, 235, 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: ' $content',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.black54),
          onPressed: () {
            _showEditDialog(context, title, content);
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, String content) {
    TextEditingController _controller = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title Düzenle'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Yeni $title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              print('Yeni $title: ${_controller.text}');
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
