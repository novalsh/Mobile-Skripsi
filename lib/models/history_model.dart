class HistoryModel {
  final int sensor;
  final int user;
  final String description;
  final String date;
  final int Branch;

  HistoryModel({
    required this.sensor,
    required this.user,
    required this.description,
    required this.date,
    required this.Branch,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      sensor: json['sensor_id'],
      user: json['user_id'],
      description: json['description'],
      date: json['date'],
      Branch: json['branch_id'],
    );
  }
}