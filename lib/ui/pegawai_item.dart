import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import 'pegawai_detail.dart';

class PegawaiItem extends StatelessWidget {
  final Pegawai pegawai;
  final ValueChanged<bool> onDetailClosed;

  const PegawaiItem({
    super.key,
    required this.pegawai,
    required this.onDetailClosed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(title: Text(pegawai.nama), subtitle: Text(pegawai.nip)),
      ),
      onTap: () async {
        final dihapus = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => PegawaiDetail(pegawai: pegawai),
          ),
        );
        onDetailClosed(dihapus == true);
      },
    );
  }
}
