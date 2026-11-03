import 'package:flutter/material.dart';

import 'helpers/user_info.dart';
import 'ui/beranda.dart';
import 'ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await UserInfo().getToken();
  runApp(MyApp(home: token == null ? const Login() : const Beranda()));
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik APP',
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
