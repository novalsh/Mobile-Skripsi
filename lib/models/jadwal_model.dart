import 'dart:ffi';

class JadwalModel {
  final double weight; // Mengubah Double menjadi double
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
      weight: (json['weight'] is int) 
          ? (json['weight'] as int).toDouble() 
          : (json['weight'] as double),
      TargetWeight: (json['TargetWeight'] is int)
          ? (json['TargetWeight'] as int).toDouble()
          : (json['TargetWeight'] as double),
      onStart: json['onStart'],
      sensor: (json['sensor_id'] is int) 
          ? json['sensor_id'] 
          : (json['sensor_id'] as double).toInt(),
      description: json['description'],
    );
  }
}