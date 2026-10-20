import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import 'pegawai_form.dart';
import 'pegawai_item.dart';
import 'pegawai_detail.dart';

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

  Future<void> _tambahPegawai() async {
    final pegawai = await Navigator.push<Pegawai>(
      context,
      MaterialPageRoute(builder: (context) => const PegawaiForm()),
    );
    if (!mounted || pegawai == null) return;

    setState(() => daftarPegawai.add(pegawai));
    final dihapus = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PegawaiDetail(pegawai: pegawai)),
    );
    if (!mounted) return;
    setState(() {
      if (dihapus == true) daftarPegawai.remove(pegawai);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pegawai"),
        actions: [
          GestureDetector(child: const Icon(Icons.add), onTap: _tambahPegawai),
        ],
      ),
      body: ListView(
        children: daftarPegawai
            .map(
              (pegawai) => PegawaiItem(
                pegawai: pegawai,
                onDetailClosed: (dihapus) => setState(() {
                  if (dihapus) daftarPegawai.remove(pegawai);
                }),
              ),
            )
            .toList(),
      ),
    );
  }
}
