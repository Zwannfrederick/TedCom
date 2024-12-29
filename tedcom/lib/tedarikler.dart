import 'package:flutter/material.dart';

class TedariklerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Oluşturulan ve Başvurulan Tedarikler',
          style: TextStyle(color: Colors.red, fontSize: 19),
        ),
      ),
      body: Column(
        children: [
          // Arama çubuğu
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
                fillColor: const Color.fromARGB(200, 255, 253, 208), // Arka plan rengi
              ),
            ),
          ),
          // Tedarik listesi
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Tedarik kutucuk sayısı
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    color: const Color.fromARGB(197, 255, 253, 226), // Kartın arka plan rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.inventory, color: Colors.red), // Sol taraftaki ikon
                      title: Text(
                        'Tedarik başlığı',
                        style: TextStyle(color: Color.fromARGB(255, 143, 12, 12)), // Başlık rengi
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Sektör: ',
                                  style: TextStyle(color: Colors.red), // 'Sektör:' kırmızı
                                ),
                                TextSpan(
                                  text: '[sektör]',
                                  style: TextStyle(color: Colors.black), // Diğer metin siyah
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Kullanıcı: ',
                                  style: TextStyle(color: Colors.red), // 'Kullanıcı:' kırmızı
                                ),
                                TextSpan(
                                  text: '[kişinin ismi]',
                                  style: TextStyle(color: Colors.black), // Diğer metin siyah
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.info_outline, color: Colors.grey), // Sağdaki ikon
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
