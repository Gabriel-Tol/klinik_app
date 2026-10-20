import 'package:flutter/material.dart';

import 'pasien_page.dart';
import 'pegawai_page.dart';
import 'poli_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _buka(BuildContext context, Widget halaman) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => halaman),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Klinik APP")),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text("Data Poli"),
              onTap: () => _buka(context, const PoliPage()),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Data Pegawai"),
              onTap: () => _buka(context, const PegawaiPage()),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Data Pasien"),
              onTap: () => _buka(context, const PasienPage()),
            ),
          ),
        ],
      ),
    );
  }
}
