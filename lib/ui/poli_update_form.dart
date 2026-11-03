import 'package:flutter/material.dart';

import '../model/poli.dart';
import '../service/poli_service.dart';

class PoliUpdateForm extends StatefulWidget {
  final Poli poli;

  const PoliUpdateForm({super.key, required this.poli});

  @override
  State<PoliUpdateForm> createState() => _PoliUpdateFormState();
}

class _PoliUpdateFormState extends State<PoliUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaPoliCtrl;

  Future<void> getData() async {
    final data = await PoliService().getById(widget.poli.id.toString());
    if (!mounted) return;
    setState(() => _namaPoliCtrl.text = data.namaPoli);
  }

  @override
  void initState() {
    super.initState();
    _namaPoliCtrl = TextEditingController(text: widget.poli.namaPoli);
    getData();
  }

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Poli")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _fieldNamaPoli(),
              const SizedBox(height: 20),
              _tombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldNamaPoli() {
    return TextField(
      decoration: const InputDecoration(labelText: "Nama Poli"),
      controller: _namaPoliCtrl,
    );
  }

  Widget _tombolSimpan() {
    return ElevatedButton(
      onPressed: () async {
        final poli = Poli(namaPoli: _namaPoliCtrl.text);
        final hasil =
            await PoliService().ubah(poli, widget.poli.id.toString());
        if (!mounted) return;
        Navigator.pop(context, hasil);
      },
      child: const Text("Simpan Perubahan"),
    );
  }
}
