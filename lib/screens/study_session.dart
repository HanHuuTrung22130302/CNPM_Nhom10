/// Represents a study session with task name, duration and timestamp
class StudySession {
  final String taskName;
  final int durationSeconds;
  final DateTime timestamp;

  //h1.3.8 chuyển dữ liệu dạng đối tượng
  StudySession({
    required this.taskName,
    required this.durationSeconds,
    required this.timestamp,
  }) : assert(taskName.isNotEmpty, 'Task name cannot be empty'),
       assert(durationSeconds > 0, 'Duration must be positive');

  /// Converts the session to a JSON map
  Map<String, dynamic> toJson() => {
    'taskName': taskName,
    'durationSeconds': durationSeconds,
    'timestamp': timestamp.toIso8601String(),
  };

  /// Creates a StudySession from a JSON map
  ///
  /// Throws FormatException if the JSON is invalid
  factory StudySession.fromJson(Map<String, dynamic> json) {
    try {
      return StudySession(
        taskName: json['taskName'] as String,
        durationSeconds: json['durationSeconds'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
    } catch (e) {
      throw FormatException('Invalid study session data: $e');
    }
  }

  /// Returns a formatted duration string (e.g. "25m 30s")
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  String toString() =>
      '$taskName - $formattedDuration - ${timestamp.toLocal()}';
}
