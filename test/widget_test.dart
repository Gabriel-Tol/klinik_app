import 'package:flutter_test/flutter_test.dart';

import 'package:klinik_app/main.dart';

void main() {
  testWidgets('Home menampilkan menu Poli, Pegawai, dan Pasien',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Data Poli'), findsOneWidget);
    expect(find.text('Data Pegawai'), findsOneWidget);
    expect(find.text('Data Pasien'), findsOneWidget);
  });

  testWidgets('Menu Data Poli membuka list lalu detail Poli Anak',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Data Poli'));
    await tester.pumpAndSettle();
    expect(find.text('Poli Anak'), findsOneWidget);

    await tester.tap(find.text('Poli Anak'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Poli'), findsOneWidget);
    expect(find.text('Nama Poli : Poli Anak'), findsOneWidget);
  });

  testWidgets('Menu Data Pegawai membuka list lalu detail pegawai',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Data Pegawai'));
    await tester.pumpAndSettle();
    expect(find.text('Budi Santoso'), findsOneWidget);

    await tester.tap(find.text('Budi Santoso'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pegawai'), findsOneWidget);
    expect(find.text('NIP : 198001012010011001'), findsOneWidget);
    expect(find.text('Email : budi@klinik.id'), findsOneWidget);
  });

  testWidgets('Menu Data Pasien membuka list lalu detail pasien',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Data Pasien'));
    await tester.pumpAndSettle();
    expect(find.text('Rina Marlina'), findsOneWidget);

    await tester.tap(find.text('Rina Marlina'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Pasien'), findsOneWidget);
    expect(find.text('No. RM : RM-0001'), findsOneWidget);
    expect(find.text('Alamat : Jl. Melati No. 10, Bandung'), findsOneWidget);
  });
}
