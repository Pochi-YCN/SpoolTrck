import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n.dart';
import '../repo_firestore.dart';
import '../models.dart';
import 'spool_scan_screen.dart';
import 'spool_detail_screen.dart';

class SpoolListScreen extends StatefulWidget {
  const SpoolListScreen({super.key});
  @override
  State<SpoolListScreen> createState() => _SpoolListScreenState();
}

class _SpoolListScreenState extends State<SpoolListScreen> {
  String query = '';
  String area = 'Taller A';
  @override
  Widget build(BuildContext context) {
    final i18n = context.read<I18n>();
    final repo = context.read<SpoolFirestoreRepository>();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>?;
    final user = args ?? {};
    return Scaffold(
      appBar: AppBar(title: Text(i18n.t('list_title'))),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(8.0), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: i18n.t('search')), onChanged: (v)=>setState(()=>query=v))),
        Expanded(child: StreamBuilder(
          stream: repo.watchSpools(area),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final spools = snapshot.data as List<SpoolItem>;
            final filtered = spools.where((s)=>s.spoolId.toLowerCase().contains(query.toLowerCase())).toList();
            if (filtered.isEmpty) return Center(child: Text(i18n.t('no_results')));
            return ListView.builder(itemCount: filtered.length, itemBuilder: (_,i){
              final s = filtered[i];
              Color color = Colors.grey;
              if (s.currentState=='in_progress') color = const Color(0xFF5a85a0);
              if (s.currentState=='done') color = const Color(0xFF6aa16a);
              return ListTile(
                leading: CircleAvatar(backgroundColor: color),
                title: Text(s.spoolId),
                subtitle: Text('${i18n.t('area')}: ${s.area} • ${s.currentState}'),
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>SpoolDetailScreen(spoolId: s.spoolId, user: user))),
              );
            });
          },
        )),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const SpoolScanScreen())), icon: const Icon(Icons.qr_code_scanner), label: Text(i18n.t('scan_qr'))),
    );
  }
}
