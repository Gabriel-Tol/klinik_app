import 'package:flutter/material.dart';

import '../model/pasien.dart';
import 'pasien_form.dart';
import 'pasien_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Pasien"),
        actions: [
          GestureDetector(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasienForm()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: daftarPasien
            .map((pasien) => PasienItem(pasien: pasien))
            .toList(),
      ),
    );
  }
}
