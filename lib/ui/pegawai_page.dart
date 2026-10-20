import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import 'pegawai_form.dart';
import 'pegawai_item.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  final List<Pegawai> daftarPegawai = [
    Pegawai(
      nip: '198001012010011001',
      nama: 'Budi Santoso',
      tanggalLahir: '1980-01-01',
      nomorTelepon: '081234567890',
      email: 'budi@klinik.id',
      password: 'rahasia123',
    ),
    Pegawai(
      nip: '198502022015022002',
      nama: 'Siti Aminah',
      tanggalLahir: '1985-02-02',
      nomorTelepon: '081298765432',
      email: 'siti@klinik.id',
      password: 'rahasia123',
    ),
    Pegawai(
      nip: '199003032020033003',
      nama: 'Andi Wijaya',
      tanggalLahir: '1990-03-03',
      nomorTelepon: '081377788899',
      email: 'andi@klinik.id',
      password: 'rahasia123',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pegawai"),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PegawaiForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: daftarPegawai
            .map((pegawai) => PegawaiItem(pegawai: pegawai))
            .toList(),
      ),
    );
  }
}
