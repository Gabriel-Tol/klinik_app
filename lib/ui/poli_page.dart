import 'package:flutter/material.dart';

import '../model/poli.dart';
import 'poli_item.dart';
import 'poli_form.dart';
import 'poli_detail.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({super.key});

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  final List<Poli> _daftarPoli = [
    Poli(namaPoli: "Poli Anak"),
    Poli(namaPoli: "Poli Kandungan"),
    Poli(namaPoli: "Poli Gigi"),
    Poli(namaPoli: "Poli THT"),
  ];

  Future<void> _tambahPoli() async {
    final poli = await Navigator.push<Poli>(
      context,
      MaterialPageRoute(builder: (context) => const PoliForm()),
    );
    if (!mounted || poli == null) return;

    setState(() => _daftarPoli.add(poli));
    final dihapus = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PoliDetail(poli: poli)),
    );
    if (!mounted) return;
    setState(() {
      if (dihapus == true) _daftarPoli.remove(poli);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Poli"),
        actions: [
          GestureDetector(child: const Icon(Icons.add), onTap: _tambahPoli),
        ],
      ),
      body: ListView(
        children: _daftarPoli
            .map(
              (poli) => PoliItem(
                poli: poli,
                onDetailClosed: (dihapus) => setState(() {
                  if (dihapus) _daftarPoli.remove(poli);
                }),
              ),
            )
            .toList(),
      ),
    );
  }
}
