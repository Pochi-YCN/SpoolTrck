import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class SpoolFirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference usersCol;
  late CollectionReference spoolsCol;

  Future<void> init() async {
    usersCol = _db.collection('users');
    spoolsCol = _db.collection('spools');
  }

  Future<Map<String,dynamic>?> getUser(String email, String password) async {
    final q = await usersCol.where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get();
    if (q.docs.isEmpty) return null;
    return q.docs.first.data() as Map<String,dynamic>;
  }

  Stream<List<SpoolItem>> watchSpools(String area) {
    return spoolsCol.where('area', isEqualTo: area).snapshots().map((snap) => snap.docs.map((d) => SpoolItem.fromMap({...d.data(), 'spoolId': d.id})).toList());
  }

  Future<void> createOrUpdateSpool(SpoolItem s) async {
    final data = s.toMap();
    await spoolsCol.doc(s.spoolId).set(data, SetOptions(merge: true));
    await spoolsCol.doc(s.spoolId).collection('history').add({
      'spoolId': s.spoolId,
      'toState': s.currentState,
      'user': s.lastUpdatedBy,
      'timestamp': DateTime.now().toIso8601String(),
      'comment': s.notes,
    });
  }

  Future<SpoolItem?> getSpool(String id) async {
    final doc = await spoolsCol.doc(id).get();
    if (!doc.exists) return null;
    return SpoolItem.fromMap({...doc.data() as Map<String,dynamic>, 'spoolId': doc.id});
  }
}
