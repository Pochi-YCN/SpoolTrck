class SpoolItem {
  final String spoolId;
  String projectNumber;
  String packageName;
  String area;
  String currentState;
  String notes;
  DateTime createdAt;
  String createdBy;
  DateTime lastUpdatedAt;
  String lastUpdatedBy;

  SpoolItem({
    required this.spoolId,
    required this.projectNumber,
    required this.packageName,
    required this.area,
    required this.currentState,
    required this.notes,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdatedAt,
    required this.lastUpdatedBy,
  });

  Map<String, dynamic> toMap() => {
    'spoolId': spoolId,
    'projectNumber': projectNumber,
    'packageName': packageName,
    'area': area,
    'currentState': currentState,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    'lastUpdatedBy': lastUpdatedBy,
  };

  factory SpoolItem.fromMap(Map<String, dynamic> m) => SpoolItem(
    spoolId: m['spoolId'],
    projectNumber: m['projectNumber'] ?? '',
    packageName: m['packageName'] ?? '',
    area: m['area'] ?? '',
    currentState: m['currentState'] ?? 'pending',
    notes: m['notes'] ?? '',
    createdAt: DateTime.parse(m['createdAt']),
    createdBy: m['createdBy'] ?? '',
    lastUpdatedAt: DateTime.parse(m['lastUpdatedAt']),
    lastUpdatedBy: m['lastUpdatedBy'] ?? '',
  );
}
