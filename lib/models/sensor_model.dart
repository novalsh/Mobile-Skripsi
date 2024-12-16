class SensorModel {
  final String code;
  final double latitude;
  final double longitude;
  final bool isOn;

  SensorModel({
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.isOn,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      code: json['code'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      isOn: json['isOn'] ?? false,
    );
  }
}
