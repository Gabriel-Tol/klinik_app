import 'package:flutter/material.dart';

import '../model/pasien.dart';
import '../service/pasien_service.dart';

class PasienUpdateForm extends StatefulWidget {
  final Pasien pasien;

  const PasienUpdateForm({super.key, required this.pasien});

  @override
  State<PasienUpdateForm> createState() => _PasienUpdateFormState();
}

class _PasienUpdateFormState extends State<PasienUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomorRmCtrl;
  late final TextEditingController _namaCtrl;
  late final TextEditingController _tanggalLahirCtrl;
  late final TextEditingController _nomorTeleponCtrl;
  late final TextEditingController _alamatCtrl;

  Future<void> getData() async {
    final data = await PasienService().getById(widget.pasien.id.toString());
    if (!mounted) return;
    setState(() {
      _nomorRmCtrl.text = data.nomorRm;
      _namaCtrl.text = data.nama;
      _tanggalLahirCtrl.text = data.tanggalLahir;
      _nomorTeleponCtrl.text = data.nomorTelepon;
      _alamatCtrl.text = data.alamat;
    });
  }

  @override
  void initState() {
    super.initState();
    _nomorRmCtrl = TextEditingController(text: widget.pasien.nomorRm);
    _namaCtrl = TextEditingController(text: widget.pasien.nama);
    _tanggalLahirCtrl = TextEditingController(text: widget.pasien.tanggalLahir);
    _nomorTeleponCtrl = TextEditingController(text: widget.pasien.nomorTelepon);
    _alamatCtrl = TextEditingController(text: widget.pasien.alamat);
    getData();
  }

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
      appBar: AppBar(title: const Text("Ubah Pasien")),
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
                onPressed: () async {
                  final pasien = Pasien(
                    id: widget.pasien.id,
                    nomorRm: _nomorRmCtrl.text,
                    nama: _namaCtrl.text,
                    tanggalLahir: _tanggalLahirCtrl.text,
                    nomorTelepon: _nomorTeleponCtrl.text,
                    alamat: _alamatCtrl.text,
                  );
                  final hasil = await PasienService()
                      .ubah(pasien, widget.pasien.id.toString());
                  if (!context.mounted) return;
                  Navigator.pop(context, hasil);
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
