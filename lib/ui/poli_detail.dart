import 'package:flutter/material.dart';

import '../model/poli.dart';
import '../service/poli_service.dart';
import 'poli_update_form.dart';

class PoliDetail extends StatefulWidget {
  final Poli poli;

  const PoliDetail({super.key, required this.poli});

  @override
  State<PoliDetail> createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  Stream<Poli> getData() async* {
    yield await PoliService().getById(widget.poli.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Poli")),
      body: StreamBuilder<Poli>(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text('Data Tidak Ditemukan');
          final poli = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Nama Poli : ${poli.namaPoli}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_tombolUbah(poli), _tombolHapus(poli)],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tombolUbah(Poli poli) {
    return ElevatedButton(
      onPressed: () async {
        final hasil = await Navigator.push<Poli>(
          context,
          MaterialPageRoute(builder: (context) => PoliUpdateForm(poli: poli)),
        );
        if (hasil == null || !mounted) return;
        // Stream hanya dibuat saat build, jadi setState = ambil ulang dari API.
        setState(() {});
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text("Ubah"),
    );
  }

  Widget _tombolHapus(Poli poli) {
    return ElevatedButton(
      onPressed: () async {
        final konfirmasi = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hapus Poli"),
            content: Text("Hapus ${poli.namaPoli}?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus"),
              ),
            ],
          ),
        );
        if (konfirmasi != true || !mounted) return;
        await PoliService().hapus(poli);
        if (!mounted) return;
        Navigator.pop(context, true);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text("Hapus"),
    );
  }
}
