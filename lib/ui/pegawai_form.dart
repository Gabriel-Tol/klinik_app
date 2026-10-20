import 'package:flutter/material.dart';

import '../model/pegawai.dart';

class PegawaiForm extends StatefulWidget {
  const PegawaiForm({super.key});

  @override
  State<PegawaiForm> createState() => _PegawaiFormState();
}

class _PegawaiFormState extends State<PegawaiForm> {
  final _formKey = GlobalKey<FormState>();
  final _nipCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nipCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pegawai")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(controller: _nipCtrl, decoration: const InputDecoration(labelText: "NIP")),
              TextField(controller: _namaCtrl, decoration: const InputDecoration(labelText: "Nama")),
              TextField(controller: _tanggalLahirCtrl, decoration: const InputDecoration(labelText: "Tanggal Lahir")),
              TextField(controller: _nomorTeleponCtrl, decoration: const InputDecoration(labelText: "Nomor Telepon")),
              TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email")),
              TextField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final pegawai = Pegawai(
                    nip: _nipCtrl.text,
                    nama: _namaCtrl.text,
                    tanggalLahir: _tanggalLahirCtrl.text,
                    nomorTelepon: _nomorTeleponCtrl.text,
                    email: _emailCtrl.text,
                    password: _passwordCtrl.text,
                  );
                  Navigator.pop(context, pegawai);
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
