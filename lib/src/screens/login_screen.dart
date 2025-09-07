import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n.dart';
import '../repo_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final i18n = context.read<I18n>();
    final repo = context.read<SpoolFirestoreRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(i18n.t('login_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: emailCtrl, decoration: InputDecoration(labelText: i18n.t('email'))),
          const SizedBox(height: 8),
          TextField(controller: passCtrl, decoration: InputDecoration(labelText: i18n.t('password')), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading ? null : () async {
              setState(() => loading = true);
              final u = await repo.getUser(emailCtrl.text.trim(), passCtrl.text.trim());
              setState(() => loading = false);
              if (u == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales inválidas'))); return; }
              Navigator.pushReplacementNamed(context, '/list', arguments: u);
            },
            child: Text(i18n.t('sign_in')),
          ),
          const SizedBox(height: 12),
          Text(i18n.t('or_demo')),
          const SizedBox(height: 6),
          Wrap(spacing: 8, children: [
            OutlinedButton(
              onPressed: () async { final u = await repo.getUser('supervisor@demo.com','demo123'); if (u!=null) Navigator.pushReplacementNamed(context, '/list', arguments: u); },
              child: Text('${i18n.t('demo_accounts')} - ${i18n.t('supervisor')}'),
            ),
            OutlinedButton(
              onPressed: () async { final u = await repo.getUser('worker@demo.com','demo123'); if (u!=null) Navigator.pushReplacementNamed(context, '/list', arguments: u); },
              child: Text('${i18n.t('demo_accounts')} - ${i18n.t('worker')}'),
            ),
          ]),
        ]),
      ),
    );
  }
}
