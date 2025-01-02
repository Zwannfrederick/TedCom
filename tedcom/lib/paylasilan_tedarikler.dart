import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tedcom/tedarik_icerik.dart';
import 'package:tedcom/tedarik_guncelle.dart';

class TedariklerScreen extends StatefulWidget {
  @override
  _TedariklerScreenState createState() => _TedariklerScreenState();
}

class _TedariklerScreenState extends State<TedariklerScreen> {
  String? currentUserName; // Giriş yapan kullanıcının adı
  String? currentUserId; // Giriş yapan kullanıcının UID'si
  bool _isLoading = true; // Verilerin yüklenme durumu
  String searchQuery = ""; // Arama sorgusu için değişken

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser(); // Kullanıcı bilgilerini al
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        currentUserId = user.uid;
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          currentUserName = doc['name']; // Kullanıcı adını al
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınamadı: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Paylaşılan Tedarikler',
          style: TextStyle(color: Colors.red, fontSize: 19),
        ),
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Arama Çubuğu
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tedarik ismine göre ara...',
                      prefixIcon: Icon(Icons.search, color: Colors.red),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase(); // Küçük harfe çevir
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tedarikler')
                        .where('tedarikSahibi', isEqualTo: currentUserName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'Henüz bir tedarik eklemediniz.',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }

                      final tedarikler = snapshot.data!.docs.where((doc) {
                        final isim = doc['isim'].toString().toLowerCase();
                        return isim.contains(searchQuery);
                      }).toList();

                      if (tedarikler.isEmpty) {
                        return const Center(
                          child: Text(
                            'Arama sonuçları bulunamadı.',
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: tedarikler.length,
                        itemBuilder: (context, index) {
                          final tedarik = tedarikler[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            elevation: 3,
                            child: Container(
                              height: 70, // Yükseklik
                              padding:
                                  const EdgeInsets.only(top: 10,right: 5,left: 5), // Kenar boşlukları
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inventory, // Kutu simgesi
                                    color: Colors.green, // Yeşil renk
                                    size: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Tedarik İsmi: ',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: tedarik['isim'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Sektör: ',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: tedarik['sektor'],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Tedarik Güncelle sayfasına geçiş
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TedarikGuncelleScreen(
                                                tedarikId: tedarik.id,
                                                tedarikData: tedarik.data()
                                                    as Map<String, dynamic>,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.info_outline,
                                            color: Colors.blue, size: 24),
                                        onPressed: () {
                                          // Tedarik içeriği ekranına yönlendirme
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TedarikIcerikScreen(
                                                tedarikId: tedarik.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
