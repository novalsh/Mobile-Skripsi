class User {
  final int id;
  final String name;
  final String role;
  final String email; // Menambahkan email
  final int branchId; // Menambahkan branchId
  final String token;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email, // Pastikan email dimasukkan di sini
    required this.branchId, // Pastikan branchId dimasukkan di sini
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'] ?? 0, // Default value
      name: json['name'] ?? 'Unknown', // Default value
      role: json['role'] ?? 'Unknown', // Default value
      email: json['email'] ?? 'unknown@example.com', // Default value
      branchId: json['branch_id'] ?? 0, // Default value
      token: token,
    );
  }
}
