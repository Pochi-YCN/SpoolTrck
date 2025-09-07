import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repo_firestore.dart';
import '../models.dart';

class SpoolDetailScreen extends StatefulWidget {
  final String spoolId;
  final Map<String,dynamic> user;
  const SpoolDetailScreen({super.key, required this.spoolId, required this.user});
  @override
  State<SpoolDetailScreen> createState() => _SpoolDetailScreenState();
}

class _SpoolDetailScreenState extends State<SpoolDetailScreen> {
  final notesCtrl = TextEditingController();
  SpoolItem? item;
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final repo = context.read<SpoolFirestoreRepository>();
    final s = await repo.getSpool(widget.spoolId);
    setState(() { item = s; loading=false; notesCtrl.text = s?.notes ?? ''; });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final repo = context.read<SpoolFirestoreRepository>();
    final isSupervisor = widget.user['role']=='supervisor';
    return Scaffold(
      appBar: AppBar(title: Text('Spool: ${item!.spoolId}')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Area: ${item!.area}'),
          const SizedBox(height:8),
          DropdownButton<String>(
            value: item!.currentState,
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Pendiente')),
              DropdownMenuItem(value: 'in_progress', child: Text('En Proceso')),
              DropdownMenuItem(value: 'done', child: Text('Terminado')),
            ],
            onChanged: (v){
              if (!isSupervisor && v=='pending') return;
              setState(()=>item!.currentState = v!);
            },
          ),
          const SizedBox(height:8),
          TextField(controller: notesCtrl, maxLines:3, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Notas')),
          const SizedBox(height:8),
          ElevatedButton(onPressed: () async {
            item!
              ..notes = notesCtrl.text
              ..lastUpdatedAt = DateTime.now()
              ..lastUpdatedBy = widget.user['email'] ?? 'demo';
            await repo.createOrUpdateSpool(item!);
            if (mounted) Navigator.pop(context);
          }, child: const Text('Guardar')),
          const SizedBox(height:12),
          const Text('Historial: se guarda en subcolección "history".'),
        ]),
      ),
    );
  }
}
