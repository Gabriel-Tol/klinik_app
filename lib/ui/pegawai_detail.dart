import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import 'pegawai_update_form.dart';

class PegawaiDetail extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetail({super.key, required this.pegawai});

  @override
  State<PegawaiDetail> createState() => _PegawaiDetailState();
}

class _PegawaiDetailState extends State<PegawaiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Pegawai")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "NIP : ${widget.pegawai.nip}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Nama : ${widget.pegawai.nama}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Tanggal Lahir : ${widget.pegawai.tanggalLahir}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Nomor Telepon : ${widget.pegawai.nomorTelepon}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Email : ${widget.pegawai.email}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pegawai = await Navigator.push<Pegawai>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PegawaiUpdateForm(pegawai: widget.pegawai),
                    ),
                  );
                  if (pegawai != null && mounted) {
                    setState(() {
                      widget.pegawai
                        ..nip = pegawai.nip
                        ..nama = pegawai.nama
                        ..tanggalLahir = pegawai.tanggalLahir
                        ..nomorTelepon = pegawai.nomorTelepon
                        ..email = pegawai.email
                        ..password = pegawai.password;
                    });
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Ubah"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
