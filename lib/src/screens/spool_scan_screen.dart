import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import '../repo_firestore.dart';

class SpoolScanScreen extends StatefulWidget {
  const SpoolScanScreen({super.key});
  @override
  State<SpoolScanScreen> createState() => _SpoolScanScreenState();
}

class _SpoolScanScreenState extends State<SpoolScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: Column(children: [
        Expanded(flex:4, child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)),
        const Expanded(flex:1, child: Center(child: Text('Apunta al QR del plano')))
      ]),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (handled) return;
      handled = true;
      final id = scanData.code ?? '';
      final repo = context.read<SpoolFirestoreRepository>();
      final exists = await repo.getSpool(id);
      if (exists==null) {
        final now = DateTime.now().toIso8601String();
        await repo.spoolsCol.doc(id).set({
          'spoolId': id,
          'projectNumber': '',
          'packageName': '',
          'area': 'Taller A',
          'currentState': 'pending',
          'notes': '',
          'createdAt': now,
          'createdBy': 'supervisor@demo.com',
          'lastUpdatedAt': now,
          'lastUpdatedBy': 'supervisor@demo.com'
        });
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/list');
    });
  }

  @override
  void dispose() { controller?.dispose(); super.dispose(); }
}
