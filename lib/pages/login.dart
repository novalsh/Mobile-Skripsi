import 'package:flutter/material.dart';
import 'package:skripsi_mobile/services/auth_services.dart';
import 'package:skripsi_mobile/models/user_model.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart'; // Pastikan import SecureStorage
import '../dashboardPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  final SecureStorage _secureStorage = SecureStorage();

  // Validasi email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Method login
  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validasi input kosong
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password tidak boleh kosong';
      });
      return;
    }

    // Validasi format email
    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Format email tidak valid';
      });
      return;
    }

    print('Attempting login with email: $email');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      User? user = await _authService.login(email, password);

      if (user != null) {
        // Simpan data user ke secure storage
        await SecureStorage.saveUserId(user.id);
        await SecureStorage.saveEmail(user.email);
        await SecureStorage.saveUser({
          'id': user.id,
          'name': user.name,
          'email': user.email
        });

        print('Navigation to DashboardPage with user: ${user.name}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Email atau password salah';
        });
        print('Login failed: User is null.');
      }
    } catch (error) {
      String errorMessage;
      if (error.toString().contains('Network')) {
        errorMessage = 'Gagal terhubung. Periksa koneksi internet';
      } else if (error.toString().contains('Unauthorized')) {
        errorMessage = 'Email atau password salah';
      } else {
        errorMessage = 'Terjadi kesalahan tidak terduga';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
      print('Login error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method reset password
  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Password'),
        content: TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Masukkan email Anda',
            hintText: 'contoh@email.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementasi reset password
              // Misalnya, panggil method reset password dari auth service
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Silakan cek email Anda')),
              );
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset(
                  'assets/images/Logo.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                // Judul login
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Form email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Form password
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                ),
                // Lupa password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol login
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40, 
                      vertical: 15
                    ),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Login", 
                        style: TextStyle(color: Colors.black)
                      ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Bersihkan controller
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}