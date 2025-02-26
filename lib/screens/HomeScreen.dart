import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniapp/models/urunler_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Homescreen> {
  UrunlerModel? _veriler;
  List<Urun> _urunler = [];

  void _loadData() async {
    // Load data from the server
    final dataString = await rootBundle.loadString('/files/data.json');
    final dataJson = jsonDecode(dataString);

    _veriler = UrunlerModel.fromJson(dataJson);
    _urunler = _veriler!.urunler;

    setState(() {});
  }

  void _filterData(int id) {
    _urunler =
        _veriler!.urunler
            .where((VerilerEleman) => VerilerEleman.kategori == id)
            .toList();
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _resetButton() {
    _urunler = _veriler!.urunler;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _veriler == null
                ? Text("Yükleniyor...")
                : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _resetButton();
                      },
                      child: Text("Tüm Ürünler"),
                    ),
                    KategoriView(),
                    UrunlerView(),
                  ],
                ),
      ),
    );
  }

  ListView UrunlerView() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _urunler.length,
      itemBuilder: (context, index) {
        final Urun urun = _urunler[index];
        return ListTile(
          leading: Image.network(
            urun.resim,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          title: Text(urun.isim),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 8),
    );
  }

  Row KategoriView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_veriler!.kategoriler.length, (index) {
        final kategori = _veriler!.kategoriler[index];
        return GestureDetector(
          onTap: () => _filterData(kategori.id),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 3,
                  offset: Offset(1, 3),
                ),
              ],
            ),
            child: Text(kategori.isim),
          ),
        );
      }),
    );
  }
}
