import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Future<DocumentSnapshot>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      _userDataFuture =
          FirebaseFirestore.instance.collection('users').doc(uid).get();
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
            padding: const EdgeInsets.symmetric(
                vertical: 20), // Yatay padding kaldırıldı
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
                      textAlign: TextAlign.center, // Merkezi hizalama
                      maxLines: 1, // Tek satırda kalmasını sağlar
                      overflow: TextOverflow.ellipsis, // Taşan metni keser
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
                      context,
                      title: 'E-mail:',
                      content: FirebaseAuth.instance.currentUser!.email ??
                          'Bilinmiyor',
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Ana Sektör:',
                      content: userData['anaSektör'] ?? '',
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Telefon Numarası:',
                      content: userData['telefonNo'] ?? '',
                    ),
                    _buildInfoCard(
                      context,
                      title: 'Doğum Tarihi:',
                      content: userData['dogumTarihi'] ?? '',
                    ),
                    _buildInfoCard(
                      context,
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

  Widget _buildInfoCard(BuildContext context,
      {required String title, required String content}) {
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
            onPressed: () async {
              try {
                String fieldToUpdate;
                switch (title) {
                  case 'Ana Sektör:':
                    fieldToUpdate = 'anaSektör';
                    break;
                  case 'Telefon Numarası:':
                    fieldToUpdate = 'telefonNo';
                    break;
                  case 'Doğum Tarihi:':
                    fieldToUpdate = 'dogumTarihi';
                    break;
                  case 'Doğum Yeri:':
                    fieldToUpdate = 'dogumYeri';
                    break;
                  default:
                    throw Exception('Geçersiz alan');
                }

                String uid = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({fieldToUpdate: _controller.text});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title başarıyla güncellendi')),
                );

                Navigator.pop(context);

                // Güncellenmiş veriyi yeniden al
                _fetchUserData();
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Güncelleme başarısız: $error')),
                );
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
