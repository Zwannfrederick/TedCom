import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilZiyaretScreen extends StatefulWidget {
  final String visitedUserId; // Ziyaret edilecek kullanıcının Firebase UID'si
  const ProfilZiyaretScreen({required this.visitedUserId});

  @override
  _ProfilZiyaretScreenState createState() => _ProfilZiyaretScreenState();
}

class _ProfilZiyaretScreenState extends State<ProfilZiyaretScreen> {
  Future<DocumentSnapshot>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    setState(() {
      _userDataFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.visitedUserId)
          .get();
    });
  }

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
            width: 500,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 252, 235, 200),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.black54,
                ),
                const SizedBox(height: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: _userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Bir hata oluştu');
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text('Kullanıcı bilgisi bulunamadı');
                    }

                    String userName =
                        snapshot.data!.get('name') ?? 'Bilinmiyor';

                    return Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(thickness: 1, height: 1),
          // Bilgi Kartları
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Bir hata oluştu'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                      child: Text('Kullanıcı bilgisi bulunamadı'));
                }

                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildInfoCard(
                      title: 'E-mail:',
                      content: userData['email'] ?? 'Bilinmiyor',
                    ),
                    _buildInfoCard(
                      title: 'Ana Sektör:',
                      content: userData['anaSektör'] ?? '',
                    ),
                    _buildInfoCard(
                      title: 'Telefon Numarası:',
                      content: userData['telefonNo'] ?? '',
                    ),
                    _buildInfoCard(
                      title: 'Doğum Tarihi:',
                      content: userData['dogumTarihi'] ?? '',
                    ),
                    _buildInfoCard(
                      title: 'Doğum Yeri:',
                      content: userData['dogumYeri'] ?? '',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
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
      ),
    );
  }
}
