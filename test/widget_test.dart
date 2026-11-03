import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:klinik_app/main.dart';
import 'package:klinik_app/ui/beranda.dart';
import 'package:klinik_app/ui/login.dart';

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
