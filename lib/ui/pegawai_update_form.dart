import 'package:flutter/material.dart';

import '../model/pegawai.dart';

class PegawaiUpdateForm extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiUpdateForm({super.key, required this.pegawai});

  @override
  State<PegawaiUpdateForm> createState() => _PegawaiUpdateFormState();
}

class _PegawaiUpdateFormState extends State<PegawaiUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nipCtrl;
  late final TextEditingController _namaCtrl;
  late final TextEditingController _tanggalLahirCtrl;
  late final TextEditingController _nomorTeleponCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;

  @override
  void initState() {
    super.initState();
    _nipCtrl = TextEditingController(text: widget.pegawai.nip);
    _namaCtrl = TextEditingController(text: widget.pegawai.nama);
    _tanggalLahirCtrl = TextEditingController(text: widget.pegawai.tanggalLahir);
    _nomorTeleponCtrl = TextEditingController(text: widget.pegawai.nomorTelepon);
    _emailCtrl = TextEditingController(text: widget.pegawai.email);
    _passwordCtrl = TextEditingController(text: widget.pegawai.password);
  }

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
      appBar: AppBar(title: const Text("Ubah Pegawai")),
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
                  Navigator.pop(
                    context,
                    Pegawai(
                      id: widget.pegawai.id,
                      nip: _nipCtrl.text,
                      nama: _namaCtrl.text,
                      tanggalLahir: _tanggalLahirCtrl.text,
                      nomorTelepon: _nomorTeleponCtrl.text,
                      email: _emailCtrl.text,
                      password: _passwordCtrl.text,
                    ),
                  );
                },
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
