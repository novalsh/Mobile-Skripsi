import 'package:flutter/material.dart';
import 'package:skripsi_mobile/pages/login.dart';
import 'package:skripsi_mobile/services/users_service.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';
import 'package:skripsi_mobile/models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String username = "Loading...";
  String email = "Loading...";
  bool isLoading = true;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk mengambil data pengguna setelah login
  Future<void> _loadUserData() async {
    final token = await SecureStorage.getToken();
    final userId = await SecureStorage.getUserId();

    print('Debugging: Token retrieved: $token');
    print('Debugging: User ID retrieved: $userId');

    if (token != null && userId != null) {
      try {
        final userService = UserService();
        final user = await userService.getUserById(userId);

        if (user != null) {
          setState(() {
            username = user.name ?? 'Tidak Diketahui';
            email = user.email ?? 'Tidak Diketahui';
            isLoading = false;
            this.userId = user.id ?? 0;
          });

          print('Debugging: User name: ${user.name}');
          print('Debugging: User email: ${user.email}');
        } else {
          setState(() {
            username = 'Gagal mengambil data';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          username = 'Terjadi kesalahan';
          isLoading = false;
        });
        print('Debugging: Error - $e');
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _updateUserData(String newName, String newEmail) async {
    try {
      final updatedData = {
        'name': newName,
        'email': newEmail,
      };

      final userService = UserService();
      await userService.updateUser(userId, updatedData);

      setState(() {
        username = newName;
        email = newEmail;
      });

      print('Debugging: User updated to name: $newName, email: $newEmail');
    } catch (e) {
      print('Debugging: Error updating user: $e');
    }
  }

  Future<void> _updatePassword(String oldPassword, String newPassword) async {
    try {
      final userService = UserService();
      await userService.updatePassword(userId, oldPassword, newPassword);

      print('Debugging: Password updated successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui!')),
      );
    } catch (e) {
      print('Debugging: Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui password!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 150, 171),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade200,
                        backgroundImage:
                            const AssetImage('assets/images/Profile.png'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildMenuItem(Icons.edit, "Edit Profile", () {
                            _showEditProfileDialog();
                          }),
                          _buildMenuItem(Icons.lock, "Change Password", () {
                            _showChangePasswordDialog();
                          }),
                          _buildMenuItem(Icons.settings, "Settings", () {}),
                          _buildMenuItem(Icons.logout, "Logout", () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 39, 86, 116),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    final TextEditingController nameController =
        TextEditingController(text: username);
    final TextEditingController emailController =
        TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 106, 150, 171),
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUserData(nameController.text, emailController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

 void _showChangePasswordDialog() {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromARGB(255, 106, 150, 171),
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Old Password",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog tanpa melakukan apa-apa
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final oldPassword = oldPasswordController.text;
              final newPassword = newPasswordController.text;

              if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                await _updatePassword(oldPassword, newPassword);
                Navigator.pop(context); // Tutup dialog setelah menyimpan
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
  }
}
