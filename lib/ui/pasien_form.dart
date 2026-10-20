import 'package:flutter/material.dart';

import '../model/pasien.dart';
import 'pasien_detail.dart';

class PasienForm extends StatefulWidget {
  const PasienForm({super.key});

  @override
  State<PasienForm> createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();

  @override
  void dispose() {
    _nomorRmCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pasien")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(controller: _nomorRmCtrl, decoration: const InputDecoration(labelText: "Nomor RM")),
              TextField(controller: _namaCtrl, decoration: const InputDecoration(labelText: "Nama")),
              TextField(controller: _tanggalLahirCtrl, decoration: const InputDecoration(labelText: "Tanggal Lahir")),
              TextField(controller: _nomorTeleponCtrl, decoration: const InputDecoration(labelText: "Nomor Telepon")),
              TextField(controller: _alamatCtrl, decoration: const InputDecoration(labelText: "Alamat")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final pasien = Pasien(
                    nomorRm: _nomorRmCtrl.text,
                    nama: _namaCtrl.text,
                    tanggalLahir: _tanggalLahirCtrl.text,
                    nomorTelepon: _nomorTeleponCtrl.text,
                    alamat: _alamatCtrl.text,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasienDetail(pasien: pasien),
                    ),
                  );
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
