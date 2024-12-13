class JadwalModel {
  final int weight;
  final String onStart;
  final int sensor;
  final String description;

  JadwalModel({
    required this.weight,
    required this.onStart,
    required this.sensor,
    required this.description,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      weight: (json['weight'] is int) ? json['weight'] : (json['weight'] as double).toInt(),
      onStart: json['onStart'],
      sensor: (json['sensor_id'] is int) ? json['sensor_id'] : (json['sensor_id'] as double).toInt(),
      description: json['description'],
    );
  }
}
