import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tedarik_olustur_guncelle.dart';
import 'tedarikler.dart';
import 'bildirimler.dart';
import 'profil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Seçili sekme indeksi
  final List<Map<String, String>> tedarikler = []; // Eklenen tedariklerin listesi
  String? _userName; // Kullanıcının ismini saklamak için bir değişken
  bool _isLoading = true; // Verinin yüklenip yüklenmediğini kontrol etmek için

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Kullanıcı adını al
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          _userName = doc['name']; // Firestore'dan isim bilgisini al
          _isLoading = false; // Veriyi yükleme tamamlandı
        });
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınamadı: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTedarikEkle(Map<String, String> yeniTedarik) {
    setState(() {
      tedarikler.add(yeniTedarik); // Yeni tedarik ekleniyor
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Seçili sekmeyi güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tüm sayfaların listesini burada oluşturuyoruz
    final pages = [
      HomeContent(
        tedarikler: tedarikler,
        userName: _userName,
        isLoading: _isLoading,
      ), // Ana sayfa içeriği
      TedariklerScreen(), // Tedarikler sayfası
      BildirimlerScreen(), // Bildirimler sayfası
      ProfilScreen(), // Profil sayfası
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages, // Burada null olmamasına dikkat edin
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TedarikOlusturGuncelleScreen(onTedarikEkle: _onTedarikEkle),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.red,
            )
          : null, // Sadece Ana Sayfa sekmesinde göster
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: 'Tedarikler'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Bildirimler'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Map<String, String>> tedarikler;
  final String? userName;
  final bool isLoading;

  HomeContent({
    required this.tedarikler,
    required this.userName,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? const Text('Hoşgeldiniz...')
            : Text('Hoşgeldiniz! ${userName ?? ''}'),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
      ),
      body: Column(
        children: [
          // Tedarik arama bölmesi
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tedarik araması',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                filled: true,
                fillColor: const Color.fromARGB(200, 255, 253, 208),
              ),
            ),
          ),
          // Tedarik kutuları
          Expanded(
            child: ListView.builder(
              itemCount: tedarikler.length,
              itemBuilder: (context, index) {
                final tedarik = tedarikler[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    color: const Color.fromARGB(197, 255, 253, 226),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.inventory),
                      title: Text(
                        tedarik['isim'] ?? '',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 143, 12, 12)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Sektör: ',
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: tedarik['sektor'] ?? '',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Açıklama: ',
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: tedarik['aciklama'] ?? '',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.info_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
