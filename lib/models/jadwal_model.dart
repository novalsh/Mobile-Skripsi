class JadwalModel {
  final double weight;
  final double TargetWeight;
  final String onStart;
  final int sensor;
  final String description;

  JadwalModel({
    required this.weight,
    required this.TargetWeight,
    required this.onStart,
    required this.sensor,
    required this.description,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      weight: (json['weight'] ?? 0).toDouble(),
      TargetWeight: (json['TargetWeight'] ?? 100).toDouble(), // Default ke 100 alih-alih 0
      onStart: json['onStart'] ?? '',
      sensor: json['sensor_id'] ?? 0,
      description: json['description'] ?? '',
    );
  }
}