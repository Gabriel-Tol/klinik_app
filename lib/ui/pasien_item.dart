import 'package:flutter/material.dart';

import '../model/pasien.dart';
import 'pasien_detail.dart';

class PasienItem extends StatelessWidget {
  final Pasien pasien;
  final ValueChanged<bool> onDetailClosed;

  const PasienItem({
    super.key,
    required this.pasien,
    required this.onDetailClosed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(pasien.nama),
          subtitle: Text(pasien.nomorRm),
        ),
      ),
      onTap: () async {
        final dihapus = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => PasienDetail(pasien: pasien)),
        );
        onDetailClosed(dihapus == true);
      },
    );
  }
}
