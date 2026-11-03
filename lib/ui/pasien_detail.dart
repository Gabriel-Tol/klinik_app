import 'package:flutter/material.dart';

import '../model/pasien.dart';
import '../service/pasien_service.dart';
import 'pasien_update_form.dart';

class PasienDetail extends StatefulWidget {
  final Pasien pasien;

  const PasienDetail({super.key, required this.pasien});

  @override
  State<PasienDetail> createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  Stream<Pasien> getData() async* {
    yield await PasienService().getById(widget.pasien.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pasien")),
      body: StreamBuilder<Pasien>(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text('Data Tidak Ditemukan');
          final pasien = snapshot.data!;
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "No. RM : ${pasien.nomorRm}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Nama : ${pasien.nama}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Tanggal Lahir : ${pasien.tanggalLahir}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Nomor Telepon : ${pasien.nomorTelepon}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Alamat : ${pasien.alamat}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_tombolUbah(pasien), _tombolHapus(pasien)],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tombolUbah(Pasien pasien) {
    return ElevatedButton(
      onPressed: () async {
        final hasil = await Navigator.push<Pasien>(
          context,
          MaterialPageRoute(
            builder: (context) => PasienUpdateForm(pasien: pasien),
          ),
        );
        if (hasil == null || !mounted) return;
        // Stream hanya dibuat saat build, jadi setState = ambil ulang dari API.
        setState(() {});
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: const Text("Ubah"),
    );
  }

  Widget _tombolHapus(Pasien pasien) {
    return ElevatedButton(
      onPressed: () async {
        final konfirmasi = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hapus Pasien"),
            content: Text("Hapus ${pasien.nama}?"),
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
        await PasienService().hapus(pasien);
        if (!mounted) return;
        Navigator.pop(context, true);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text("Hapus"),
    );
  }
}
