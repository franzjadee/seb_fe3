class Bug {
  int? id;
  final String projectName;
  final String bugType;
  final String severity;
  final bool isResolved;

  Bug({
    this.id,
    required this.projectName,
    required this.bugType,
    required this.severity,
    this.isResolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'bugType': bugType,
      'severity': severity,
      'isResolved': isResolved ? 1 : 0,
    };
  }

  factory Bug.fromMap(Map<String, dynamic> map) {
    return Bug(
      id: map['id'],
      projectName: map['projectName'],
      bugType: map['bugType'],
      severity: map['severity'],
      isResolved: map['isResolved'] == 1,
    );
  }
}
