import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class I18n extends ChangeNotifier {
  Map<String, String> _map = {};
  String current = 'es';
  String t(String key) => _map[key] ?? key;
  Future<void> load([String lang = 'es']) async {
    current = lang;
    final data = await rootBundle.loadString('assets/i18n/$lang.json');
    final jsonMap = json.decode(data) as Map<String, dynamic>;
    _map = jsonMap.map((k, v) => MapEntry(k, v.toString()));
    notifyListeners();
  }
}
