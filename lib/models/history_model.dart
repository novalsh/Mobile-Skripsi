class HistoryModel {
  final int id;
  final int sensorId;
  final int userId;
  final String description;
  final String date;
  final int branchId;

  HistoryModel({
    required this.id,
    required this.sensorId,
    required this.userId,
    required this.description,
    required this.date,
    required this.branchId,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      sensorId: json['sensor_id'],
      userId: json['user_id'],
      description: json['description'],
      date: json['date'],
      branchId: json['branch_id'],
    );
  }
}
