class JadwalModel {
  final int weight;
  final String onStart;
  final int sensor;

  JadwalModel({
    required this.weight,
    required this.onStart,
    required this.sensor,
  });

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    return JadwalModel(
      weight: json['weight'],              
      onStart: json['onStart'],            
      sensor: json['sensor_id'],          
    );
  }
}
