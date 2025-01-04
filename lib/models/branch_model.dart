class BranchModel {
  int id;
  String city;

  BranchModel({
    required this.id,
    required this.city,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      city: json['city'],
    );
  }
}