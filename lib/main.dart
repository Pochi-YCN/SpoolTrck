import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'src/i18n.dart';
import 'src/repo_firestore.dart';
import 'src/screens/login_screen.dart';
import 'src/screens/spool_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final repo = SpoolFirestoreRepository();
  await repo.init();
  runApp(SpoolTrackApp(repo: repo));
}

class SpoolTrackApp extends StatelessWidget {
  final SpoolFirestoreRepository repo;
  const SpoolTrackApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => I18n()..load()),
        Provider.value(value: repo),
      ],
      child: Consumer<I18n>(builder: (_, i18n, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: i18n.t('app_name'),
          theme: ThemeData(useMaterial3: true),
          home: const LoginScreen(),
          routes: {'/list': (_) => const SpoolListScreen()},
        );
      }),
    );
  }
}
