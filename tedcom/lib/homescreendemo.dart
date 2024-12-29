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
  String? userName; // Kullanıcının ismini saklamak için
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
          userName = doc['name']; // Firestore'dan isim bilgisini al
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

  void _onTedarikEkle(Map<String, String> yeniTedarik) {
    FirebaseFirestore.instance.collection('tedarikler').add({
      'isim': yeniTedarik['isim'],
      'sektor': yeniTedarik['sektor'],
      'aciklama': yeniTedarik['aciklama'],
      'ekleyen': userName ?? 'Bilinmeyen',
      'tarih': DateTime.now(),
    }).then((_) {
      print('Tedarik başarıyla Firestore\'a eklendi.');
    }).catchError((error) {
      print('Tedarik eklenirken hata oluştu: $error');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeContent(userName: userName, isLoading: _isLoading), // Ana sayfa içeriği
      TedariklerScreen(), // Tedarikler sayfası
      BildirimlerScreen(), // Bildirimler sayfası
      ProfilScreen(), // Profil sayfası
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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
          : null,
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

class HomeContent extends StatefulWidget {
  final String? userName;
  final bool isLoading;

  HomeContent({required this.userName, required this.isLoading});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String searchQuery = ""; // Kullanıcının arama sorgusu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isLoading
            ? const Text('Hoşgeldiniz...')
            : Text('Hoşgeldiniz! ${widget.userName ?? ''}'),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.red, fontSize: 20),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase(); // Sorguyu küçük harfe çevir
                });
              },
              decoration: InputDecoration(
                hintText: "Tedarik Ara...",
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tedarikler').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Henüz tedarik yok.'));
          }

          final tedarikler = snapshot.data!.docs.where((doc) {
            final isim = doc['isim'].toString().toLowerCase();
            final sektor = doc['sektor'].toString().toLowerCase();
            return isim.contains(searchQuery) || sektor.contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: tedarikler.length,
            itemBuilder: (context, index) {
              final tedarik = tedarikler[index];
              return Card(
                child: ListTile(
                  title: Text(tedarik['isim']),
                  subtitle: Text(tedarik['sektor']),
                  trailing: Text('Ekleyen: ${tedarik['ekleyen']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}