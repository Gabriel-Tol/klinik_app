import 'package:flutter/material.dart';

import '../model/poli.dart';
import '../service/poli_service.dart';
import '../widget/sidebar.dart';
import 'poli_detail.dart';
import 'poli_form.dart';
import 'poli_item.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({super.key});

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  Stream<List<Poli>> getList() async* {
    yield await PoliService().listData();
  }

  Future<void> _tambahPoli() async {
    final poli = await Navigator.push<Poli>(
      context,
      MaterialPageRoute(builder: (context) => const PoliForm()),
    );
    if (!mounted || poli == null) return;

    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => PoliDetail(poli: poli)),
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
        title: const Text("Data Poli"),
        actions: [
          GestureDetector(onTap: _tambahPoli, child: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Poli>>(
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
            itemBuilder: (context, index) => PoliItem(
              poli: data[index],
              onDetailClosed: (_) => setState(() {}),
            ),
          );
        },
      ),
    );
  }
}
