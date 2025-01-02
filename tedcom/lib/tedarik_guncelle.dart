import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TedarikGuncelleScreen extends StatefulWidget {
  final String tedarikId;
  final Map<String, dynamic> tedarikData;

  TedarikGuncelleScreen({
    required this.tedarikId,
    required this.tedarikData,
  });

  @override
  _TedarikGuncelleScreenState createState() => _TedarikGuncelleScreenState();
}

class _TedarikGuncelleScreenState extends State<TedarikGuncelleScreen> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _sektorController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isimController.text = widget.tedarikData['isim'] ?? '';
    _sektorController.text = widget.tedarikData['sektor'] ?? '';
    _aciklamaController.text = widget.tedarikData['aciklama'] ?? '';
  }

  void _guncelleTedarik() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('tedarikler')
            .doc(widget.tedarikId)
            .update({
          'isim': _isimController.text,
          'sektor': _sektorController.text,
          'aciklama': _aciklamaController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tedarik başarıyla güncellendi.')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Güncelleme hatası: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Güncelleme sırasında hata oluştu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tedarik Güncelle',
          style: TextStyle(color: Colors.red),
        ),
        iconTheme: const IconThemeData(color: Colors.red),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tedarik İsmi',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _isimController,
                decoration: InputDecoration(
                  hintText: 'Tedarik İsmi',
                  filled: true,
                  fillColor: Colors.red[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik ismi boş bırakılamaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Tedarik Sektörü',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sektorController,
                decoration: InputDecoration(
                  hintText: 'Tedarik Sektörü',
                  filled: true,
                  fillColor: Colors.red[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik sektörü boş bırakılamaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Tedarik Açıklaması',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _aciklamaController,
                decoration: InputDecoration(
                  hintText: 'Tedarik Açıklaması',
                  filled: true,
                  fillColor: Colors.red[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik açıklaması boş bırakılamaz.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _guncelleTedarik,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Güncelle',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
