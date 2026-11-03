import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:klinik_app/helpers/api_client.dart';
import 'package:klinik_app/main.dart';
import 'package:klinik_app/ui/beranda.dart';
import 'package:klinik_app/ui/login.dart';

/// Server palsu yang meniru REST json-server (db.json), supaya widget test
/// tidak melakukan request jaringan sungguhan. Data di-reset tiap test.
class _MockJsonServer implements HttpClientAdapter {
  final _db = <String, List<Map<String, dynamic>>>{
    'poli': [
      {'id': 1, 'nama_poli': 'Poli Anak'},
      {'id': 2, 'nama_poli': 'Poli Kandungan'},
      {'id': 3, 'nama_poli': 'Poli Gigi'},
      {'id': 4, 'nama_poli': 'Poli THT'},
    ],
    'pegawai': [
      {
        'id': 1,
        'nip': '198001012010011001',
        'nama': 'Budi Santoso',
        'tanggal_lahir': '1980-01-01',
        'nomor_telepon': '081234567890',
        'email': 'budi@klinik.id',
        'password': 'rahasia123',
      },
      {
        'id': 2,
        'nip': '198502022015022002',
        'nama': 'Siti Aminah',
        'tanggal_lahir': '1985-02-02',
        'nomor_telepon': '081298765432',
        'email': 'siti@klinik.id',
        'password': 'rahasia123',
      },
      {
        'id': 3,
        'nip': '199003032020033003',
        'nama': 'Andi Wijaya',
        'tanggal_lahir': '1990-03-03',
        'nomor_telepon': '081377788899',
        'email': 'andi@klinik.id',
        'password': 'rahasia123',
      },
    ],
    'pasien': [
      {
        'id': 1,
        'nomor_rm': 'RM-0001',
        'nama': 'Rina Marlina',
        'tanggal_lahir': '1992-07-15',
        'nomor_telepon': '081111222333',
        'alamat': 'Jl. Melati No. 10, Bandung',
      },
      {
        'id': 2,
        'nomor_rm': 'RM-0002',
        'nama': 'Dedi Kurniawan',
        'tanggal_lahir': '1987-11-23',
        'nomor_telepon': '082222333444',
        'alamat': 'Jl. Mawar No. 5, Bandung',
      },
      {
        'id': 3,
        'nomor_rm': 'RM-0003',
        'nama': 'Putri Anggraini',
        'tanggal_lahir': '2001-03-08',
        'nomor_telepon': '083333444555',
        'alamat': 'Jl. Kenanga No. 7, Bandung',
      },
    ],
  };

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    final segments =
        options.uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final rows = segments.isEmpty ? null : _db[segments.first];
    if (rows == null || segments.length > 2) return _notFound();
    final id = segments.length == 2 ? segments[1] : null;

    switch (options.method) {
      case 'GET':
        if (id == null) return _json(rows);
        final hasil = rows.where((row) => row['id'].toString() == id);
        return hasil.isEmpty ? _notFound() : _json(hasil.first);
      case 'POST':
        final row = {'id': _nextId(rows), ...await _readBody(requestStream)};
        rows.add(row);
        return _json(row, status: 201);
      case 'PUT':
        final index = rows.indexWhere((row) => row['id'].toString() == id);
        if (index < 0) return _notFound();
        final row = {
          'id': rows[index]['id'],
          ...await _readBody(requestStream),
        };
        rows[index] = row;
        return _json(row);
      case 'DELETE':
        rows.removeWhere((row) => row['id'].toString() == id);
        // json-server membalas DELETE dengan body kosong.
        return ResponseBody.fromString('', 200);
      default:
        return _notFound();
    }
  }

  int _nextId(List<Map<String, dynamic>> rows) => rows.isEmpty
      ? 1
      : rows.map((row) => row['id'] as int).reduce((a, b) => a > b ? a : b) + 1;

  Future<Map<String, dynamic>> _readBody(Stream<Uint8List>? stream) async {
    if (stream == null) return <String, dynamic>{};
    final bytes =
        await stream.fold<List<int>>(<int>[], (prev, c) => prev..addAll(c));
    if (bytes.isEmpty) return <String, dynamic>{};
    return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  }

  ResponseBody _json(Object data, {int status = 200}) => ResponseBody.fromString(
        jsonEncode(data),
        status,
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      );

  ResponseBody _notFound() => _json({'message': 'Not Found'}, status: 404);

  @override
  void close({bool force = false}) {}
}

Future<void> _bukaDrawer(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
}

Future<void> _isiLogin(WidgetTester tester, String user, String pass) async {
  await tester.enterText(find.byType(TextFormField).at(0), user);
  await tester.enterText(find.byType(TextFormField).at(1), pass);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUp(() => dio.httpClientAdapter = _MockJsonServer());

  testWidgets('Login gagal menampilkan pesan tidak valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Login()));

    await _isiLogin(tester, 'salah', 'salah');
    expect(find.text('Username atau Password Tidak Valid'), findsOneWidget);
  });

  testWidgets('Login admin/admin membuka Beranda',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Login()));

    await _isiLogin(tester, 'admin', 'admin');
    expect(find.text('Selamat Datang'), findsOneWidget);
  });

  testWidgets('Beranda menampilkan Selamat Datang dan menu sidebar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));

    expect(find.text('Selamat Datang'), findsOneWidget);

    await _bukaDrawer(tester);
    expect(find.text('Poli'), findsOneWidget);
    expect(find.text('Pegawai'), findsOneWidget);
    expect(find.text('Pasien'), findsOneWidget);
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('Menu Poli dari sidebar membuka list lalu detail Poli Anak',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);

    await tester.tap(find.text('Poli'));
    await tester.pumpAndSettle();
    expect(find.text('Poli Anak'), findsOneWidget);

    await tester.tap(find.text('Poli Anak'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Poli'), findsOneWidget);
    expect(find.text('Nama Poli : Poli Anak'), findsOneWidget);
  });

  testWidgets('Menu Pegawai dari sidebar membuka list lalu detail pegawai',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);

    await tester.tap(find.text('Pegawai'));
    await tester.pumpAndSettle();
    expect(find.text('Budi Santoso'), findsOneWidget);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pegawai'), findsOneWidget);
    expect(find.text('NIP : 198001012010011001'), findsOneWidget);
    expect(find.text('Email : budi@klinik.id'), findsOneWidget);
  });

  testWidgets('Menu Pasien dari sidebar membuka list lalu detail pasien',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);

    await tester.tap(find.text('Pasien'));
    await tester.pumpAndSettle();
    expect(find.text('Rina Marlina'), findsOneWidget);

    await tester.tap(find.text('Rina Marlina'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pasien'), findsOneWidget);
    expect(find.text('No. RM : RM-0001'), findsOneWidget);
    expect(find.text('Alamat : Jl. Melati No. 10, Bandung'), findsOneWidget);
  });

  testWidgets('Tambah poli tersimpan lewat API lalu membuka detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);
    await tester.tap(find.text('Poli'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Poli Mata');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Poli'), findsOneWidget);
    expect(find.text('Nama Poli : Poli Mata'), findsOneWidget);
  });

  testWidgets('Ubah poli tersimpan lewat API lalu tampil di detail dan list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);
    await tester.tap(find.text('Poli'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Poli Anak'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Ubah'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Poli Anak Baru');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan Perubahan'));
    await tester.pumpAndSettle();

    // Detail mengambil ulang data dari API setelah perubahan.
    expect(find.text('Nama Poli : Poli Anak Baru'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Poli Anak Baru'), findsOneWidget);
  });

  testWidgets('Hapus pegawai minta konfirmasi: Batal batal, Hapus menghapus',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(home: Beranda()));
    await _bukaDrawer(tester);
    await tester.tap(find.text('Pegawai'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();

    // Tombol Hapus membuka dialog konfirmasi, Batal membatalkan.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus Pegawai'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pegawai'), findsOneWidget);

    // Kali ini konfirmasi: item hilang dari list.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Data Pegawai'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);
    expect(find.text('Siti Aminah'), findsOneWidget);
  });
}
