import 'package:flutter/material.dart';

class TedarikOlusturGuncelleScreen extends StatefulWidget {
  final Function(Map<String, String>) onTedarikEkle; // Tedarik ekleme fonksiyonu

  TedarikOlusturGuncelleScreen({required this.onTedarikEkle});

  @override
  _TedarikOlusturGuncelleScreenState createState() => _TedarikOlusturGuncelleScreenState();
}

class _TedarikOlusturGuncelleScreenState extends State<TedarikOlusturGuncelleScreen> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _sektorController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  List<String> ekler = [];

  void _galeriAc() async {
    // Galeri açma işlemi (örnek, simülasyon için)
    setState(() {
      ekler.add('Ek ${ekler.length + 1}');
    });
  }

  void _ekSil(int index) {
    setState(() {
      ekler.removeAt(index);
    });
  }

  void _paylas() {
    if (_isimController.text.isNotEmpty && _sektorController.text.isNotEmpty) {
      widget.onTedarikEkle({
        'isim': _isimController.text,
        'sektor': _sektorController.text,
        'aciklama': _aciklamaController.text,
      });
      Navigator.pop(context); // Ana sayfaya dön
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tedarik Oluştur veya Güncelle',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tedarik İsmi', style: TextStyle(color: Colors.red, fontSize: 16)),
            TextField(
              controller: _isimController,
              decoration: InputDecoration(
                hintText: 'Tedarik İsmini Giriniz',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 239, 210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tedarik Sektörü', style: TextStyle(color: Colors.red, fontSize: 16)),
            TextField(
              controller: _sektorController,
              decoration: InputDecoration(
                hintText: 'Tedarik Sektörünü Giriniz',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 239, 210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tedarik Açıklaması', style: TextStyle(color: Colors.red, fontSize: 16)),
            TextField(
              controller: _aciklamaController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tedarik Açıklaması',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 239, 210),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tedariğinize Ek Ekleyin', style: TextStyle(color: Colors.red, fontSize: 16)),
                IconButton(
                  onPressed: _galeriAc,
                  icon: const Icon(Icons.attach_file, color: Colors.red),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ekler.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ekler[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _ekSil(index),
                    ),
                  );
                },
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: _paylas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Paylaş', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
