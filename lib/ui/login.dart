import 'package:flutter/material.dart';

import '../service/login_service.dart';
import 'beranda.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login Admin",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                const SizedBox(height: 50),
                Center(
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Column(
                        children: [
                          _usernameTextField(),
                          const SizedBox(height: 20),
                          _passwordTextField(),
                          const SizedBox(height: 40),
                          _tombolLogin(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Username"),
      controller: _usernameCtrl,
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      obscureText: true,
      controller: _passwordCtrl,
    );
  }

  Widget _tombolLogin() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child:
          ElevatedButton(onPressed: _prosesLogin, child: const Text("Login")),
    );
  }

  Future<void> _prosesLogin() async {
    final valid =
        await LoginService().login(_usernameCtrl.text, _passwordCtrl.text);
    if (!mounted) return;
    if (valid) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Beranda()));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("Username atau Password Tidak Valid"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
