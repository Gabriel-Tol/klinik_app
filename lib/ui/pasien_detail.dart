import 'package:flutter/material.dart';

import '../model/pasien.dart';
import 'pasien_update_form.dart';

class PasienDetail extends StatefulWidget {
  final Pasien pasien;

  const PasienDetail({super.key, required this.pasien});

  @override
  State<PasienDetail> createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Pasien")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "No. RM : ${widget.pasien.nomorRm}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Nama : ${widget.pasien.nama}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Tanggal Lahir : ${widget.pasien.tanggalLahir}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Nomor Telepon : ${widget.pasien.nomorTelepon}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "Alamat : ${widget.pasien.alamat}",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pasien = await Navigator.push<Pasien>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PasienUpdateForm(pasien: widget.pasien),
                    ),
                  );
                  if (pasien != null && mounted) {
                    setState(() {
                      widget.pasien
                        ..nomorRm = pasien.nomorRm
                        ..nama = pasien.nama
                        ..tanggalLahir = pasien.tanggalLahir
                        ..nomorTelepon = pasien.nomorTelepon
                        ..alamat = pasien.alamat;
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
