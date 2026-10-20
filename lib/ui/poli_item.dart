import 'package:flutter/material.dart';

import '../model/poli.dart';
import 'poli_detail.dart';

class PoliItem extends StatelessWidget {
  final Poli poli;
  final ValueChanged<bool> onDetailClosed;

  const PoliItem({super.key, required this.poli, required this.onDetailClosed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(child: ListTile(title: Text(poli.namaPoli))),
      onTap: () async {
        final dihapus = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => PoliDetail(poli: poli)),
        );
        onDetailClosed(dihapus == true);
      },
    );
  }
}
