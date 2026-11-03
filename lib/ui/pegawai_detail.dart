import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import '../service/pegawai_service.dart';
import 'pegawai_update_form.dart';

class PegawaiDetail extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetail({super.key, required this.pegawai});

  @override
  State<PegawaiDetail> createState() => _PegawaiDetailState();
}

class _PegawaiDetailState extends State<PegawaiDetail> {
  Stream<Pegawai> getData() async* {
    yield await PegawaiService().getById(widget.pegawai.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pegawai")),
      body: StreamBuilder<Pegawai>(
        stream: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text('Data Tidak Ditemukan');
          final pegawai = snapshot.data!;
          // Password sengaja tidak ditampilkan di halaman detail.
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "NIP : ${pegawai.nip}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Nama : ${pegawai.nama}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Tanggal Lahir : ${pegawai.tanggalLahir}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Nomor Telepon : ${pegawai.nomorTelepon}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                "Email : ${pegawai.email}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [_tombolUbah(pegawai), _tombolHapus(pegawai)],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tombolUbah(Pegawai pegawai) {
    return ElevatedButton(
      onPressed: () async {
        final hasil = await Navigator.push<Pegawai>(
          context,
          MaterialPageRoute(
            builder: (context) => PegawaiUpdateForm(pegawai: pegawai),
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

  Widget _tombolHapus(Pegawai pegawai) {
    return ElevatedButton(
      onPressed: () async {
        final konfirmasi = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Hapus Pegawai"),
            content: Text("Hapus ${pegawai.nama}?"),
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
        await PegawaiService().hapus(pegawai);
        if (!mounted) return;
        Navigator.pop(context, true);
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text("Hapus"),
    );
  }
}
