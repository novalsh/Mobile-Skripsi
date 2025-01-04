class SensorModel {
  final int id;
  final String code;
  final double latitude;
  final double longitude;
  final bool isOn;
  final bool isOpen;
  final int branch_id;

  SensorModel({
    required this.id,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.isOn,
    required this.isOpen,
    required this.branch_id,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      code: json['code'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      isOn: json['isOn'] ?? false, 
      isOpen: json['isOpen'] ?? false,
      branch_id: json['branch_id'],
      id: json['id'],

    );
  }
}
