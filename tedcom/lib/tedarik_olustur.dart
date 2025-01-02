import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TedarikOlusturScreen extends StatefulWidget {
  final Function(Map<String, String>) onTedarikEkle;

  TedarikOlusturScreen({required this.onTedarikEkle});

  @override
  _TedarikOlusturScreenState createState() =>
      _TedarikOlusturScreenState();
}

class _TedarikOlusturScreenState
    extends State<TedarikOlusturScreen> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _sektorController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  final List<File> ekler = []; // Fotoğraflar için liste

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form anahtarı

  // Galeriyi aç ve fotoğraf seç
  void _galeriAc() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        ekler.add(File(pickedFile.path));
      });
    }
  }

  void _ekSil(int index) {
    setState(() {
      ekler.removeAt(index);
    });
  }

  void _paylas() {
    if (_formKey.currentState!.validate()) {
      widget.onTedarikEkle({
        'isim': _isimController.text,
        'sektor': _sektorController.text,
        'aciklama': _aciklamaController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tedarik Oluştur',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Form widgetine anahtar ekledik
          child: Column(
            children: [
              TextFormField(
                controller: _isimController,
                decoration: InputDecoration(
                  hintText: 'Tedarik İsmi',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 239, 210),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik ismi boş bırakılamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sektorController,
                decoration: InputDecoration(
                  hintText: 'Tedarik Sektörü',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 239, 210),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik sektörü boş bırakılamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aciklamaController,
                decoration: InputDecoration(
                  hintText: 'Tedarik Açıklaması',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 239, 210),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tedarik açıklaması boş bırakılamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tedariğinize Ek Ekleyin',
                      style: TextStyle(color: Colors.red, fontSize: 16)),
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
                      leading: Image.file(
                        ekler[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text('Ek ${index + 1}'),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Paylaş',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
