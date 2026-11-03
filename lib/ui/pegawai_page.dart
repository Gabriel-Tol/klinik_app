import 'package:flutter/material.dart';

import '../model/pegawai.dart';
import '../service/pegawai_service.dart';
import '../widget/sidebar.dart';
import 'pegawai_detail.dart';
import 'pegawai_form.dart';
import 'pegawai_item.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({super.key});

  @override
  State<PegawaiPage> createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  Stream<List<Pegawai>> getList() async* {
    yield await PegawaiService().listData();
  }

  Future<void> _tambahPegawai() async {
    final pegawai = await Navigator.push<Pegawai>(
      context,
      MaterialPageRoute(builder: (context) => const PegawaiForm()),
    );
    if (!mounted || pegawai == null) return;

    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PegawaiDetail(pegawai: pegawai)),
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
        title: const Text("Data Pegawai"),
        actions: [
          GestureDetector(onTap: _tambahPegawai, child: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Pegawai>>(
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
            itemBuilder: (context, index) => PegawaiItem(
              pegawai: data[index],
              onDetailClosed: (_) => setState(() {}),
            ),
          );
        },
      ),
    );
  }
}
