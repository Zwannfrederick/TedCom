import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TedarikIcerikScreen extends StatelessWidget {
  final String tedarikId; // İlgili tedariğin ID'si

  TedarikIcerikScreen({required this.tedarikId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tedarik İçeriği',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.black, height: 1),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('tedarikler')
            .doc(tedarikId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Tedarik bulunamadı.'));
          }

          final tedarik = snapshot.data!.data() as Map<String, dynamic>;
          final ekler = tedarik['ekler'] ?? [];
          final basvurular = tedarik['basvurular'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tedariği oluşturan kişinin bilgisi
                Text(
                  'Tedariği Oluşturan',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tedarik['tedarikSahibi'] ?? 'Bilinmeyen',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 24),

                // Tedarik ismi
                Text(
                  'Tedarik İsmi',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tedarik['isim'] ?? 'Belirtilmemiş',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 24),

                // Tedarik sektörü
                Text(
                  'Tedarik Sektörü',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tedarik['sektor'] ?? 'Belirtilmemiş',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 24),

                // Tedarik açıklaması
                Text(
                  'Tedarik Açıklaması',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tedarik['aciklama'] ?? 'Belirtilmemiş',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 24),

                // Tedarik ekleri
                Text(
                  'Tedarik Ekleri',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (ekler.isEmpty)
                  const Text('Ek yok.', style: TextStyle(fontSize: 16))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ekler.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Ek ${index + 1}'),
                        subtitle: Text(ekler[index]),
                        leading: const Icon(Icons.attach_file, color: Colors.red),
                      );
                    },
                  ),
                const Divider(height: 24),

                // Başvurular
                Text(
                  'Başvurular',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (basvurular.isEmpty)
                  const Text('Başvuru yok.', style: TextStyle(fontSize: 16))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: basvurular.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.red),
                        title: Text(basvurular[index]),
                      );
                    },
                  ),
                const SizedBox(height: 24),

                // Başvuru yap butonu
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final doc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .get();
                          final userName = doc['name'];

                          // Kullanıcı kendi tedariğine başvurmaya çalışıyorsa
                          if (tedarik['tedarikSahibi'] == userName) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Kendi tedariğinize başvuramazsınız.')),
                            );
                            return;
                          }

                          await FirebaseFirestore.instance
                              .collection('tedarikler')
                              .doc(tedarikId)
                              .update({
                            'basvurular': FieldValue.arrayUnion([userName]),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Başvurunuz alınmıştır.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Kullanıcı bilgisi bulunamadı.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bir hata oluştu: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text(
                      'Başvuru Yap',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
