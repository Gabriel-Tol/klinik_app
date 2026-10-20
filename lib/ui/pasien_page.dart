import 'package:flutter/material.dart';

import '../model/pasien.dart';
import 'pasien_form.dart';
import 'pasien_item.dart';
import 'pasien_detail.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  final List<Pasien> daftarPasien = [
    Pasien(
      nomorRm: 'RM-0001',
      nama: 'Rina Marlina',
      tanggalLahir: '1992-07-15',
      nomorTelepon: '081111222333',
      alamat: 'Jl. Melati No. 10, Bandung',
    ),
    Pasien(
      nomorRm: 'RM-0002',
      nama: 'Dedi Kurniawan',
      tanggalLahir: '1987-11-23',
      nomorTelepon: '082222333444',
      alamat: 'Jl. Mawar No. 5, Bandung',
    ),
    Pasien(
      nomorRm: 'RM-0003',
      nama: 'Putri Anggraini',
      tanggalLahir: '2001-03-08',
      nomorTelepon: '083333444555',
      alamat: 'Jl. Kenanga No. 7, Bandung',
    ),
  ];

  Future<void> _tambahPasien() async {
    final pasien = await Navigator.push<Pasien>(
      context,
      MaterialPageRoute(builder: (context) => const PasienForm()),
    );
    if (!mounted || pasien == null) return;

    setState(() => daftarPasien.add(pasien));
    final dihapus = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PasienDetail(pasien: pasien)),
    );
    if (!mounted) return;
    setState(() {
      if (dihapus == true) daftarPasien.remove(pasien);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pasien"),
        actions: [
          GestureDetector(child: const Icon(Icons.add), onTap: _tambahPasien),
        ],
      ),
      body: ListView(
        children: daftarPasien
            .map(
              (pasien) => PasienItem(
                pasien: pasien,
                onDetailClosed: (dihapus) => setState(() {
                  if (dihapus) daftarPasien.remove(pasien);
                }),
              ),
            )
            .toList(),
      ),
    );
  }
}
