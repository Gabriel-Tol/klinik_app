import 'package:flutter/material.dart';

import '../model/pasien.dart';
import '../service/pasien_service.dart';
import '../widget/sidebar.dart';
import 'pasien_detail.dart';
import 'pasien_form.dart';
import 'pasien_item.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  Stream<List<Pasien>> getList() async* {
    yield await PasienService().listData();
  }

  Future<void> _tambahPasien() async {
    final pasien = await Navigator.push<Pasien>(
      context,
      MaterialPageRoute(builder: (context) => const PasienForm()),
    );
    if (!mounted || pasien == null) return;

    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PasienDetail(pasien: pasien)),
    );
    if (!mounted) return;
    // setState membuat stream getList() baru, jadi daftar diambil ulang dari API.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Pasien"),
        actions: [
          GestureDetector(onTap: _tambahPasien, child: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Pasien>>(
        stream: getList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Text('Data Kosong');
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => PasienItem(
              pasien: data[index],
              onDetailClosed: (_) => setState(() {}),
            ),
          );
        },
      ),
    );
  }
}
