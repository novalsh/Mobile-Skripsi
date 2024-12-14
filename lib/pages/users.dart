import 'package:flutter/material.dart';
import 'package:skripsi_mobile/pages/login.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String username = "John Doe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 150, 171),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade200,
                  backgroundImage:
                      const AssetImage('assets/images/Profile.png'),
                ),
                const SizedBox(height: 20),

                // Username
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Email
                const Text(
                  "johndoe@example.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),

                // Menu List
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMenuItem(Icons.person, "Edit Profile", () {
                      _showEditProfileDialog();
                    }),
                    _buildMenuItem(Icons.lock, "Change Password", () {
                      // Aksi saat Change Password di-tap
                    }),
                    _buildMenuItem(Icons.settings, "Settings", () {
                      // Aksi saat Settings di-tap
                    }),
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

  // Widget untuk item menu
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(255, 39, 86, 116), // Sama seperti dashboard
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

  // Dialog pop-up untuk mengedit profil
  void _showEditProfileDialog() {
    final TextEditingController nameController =
        TextEditingController(text: username);

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
          content: TextField(
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog tanpa menyimpan
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  username = nameController.text;
                });
                Navigator.pop(context); // Tutup dialog dan simpan perubahan
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
