import 'package:flutter/material.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 150, 171), 
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Sensor Page",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), 

            // Tabel data
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                decoration: BoxDecoration(
                  color: const Color(0x00275674),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 39, 86, 116), 
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Code",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Branch",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "latitude",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "longitude",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Status",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Isi tabel
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTableRow(0, "1", "Branch 1", "1.234", "2.345", true),
                          _buildTableRow(1, "2", "Branch 2", "1.234", "2.345", false),
                          _buildTableRow(2, "3", "Branch 3", "1.234", "2.345", true),
                          _buildTableRow(3, "4", "Branch 4", "1.234", "2.345", false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(int index, String code, String branch, String longitute, String latitude, bool isOnline) {
    // Menentukan warna berdasarkan indeks ganjil atau genap
    Color rowColor = (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor, 
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(code),
          _buildTableCell(branch),
          _buildTableCell(longitute),
          _buildTableCell(latitude),
          _buildTableCell(isOnline ? "Online" : "Offline"),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
