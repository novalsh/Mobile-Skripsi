import 'package:flutter/material.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D47A1), // Biru cerah
            Color(0xFF0D47A1), // Ungu
          ], // Ungu muda -> Biru cerah
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          "Welcome to Alat Page!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
