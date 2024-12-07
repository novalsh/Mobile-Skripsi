import 'package:flutter/material.dart';

class KolamPage extends StatelessWidget {
  const KolamPage({super.key});

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
                    "JadwalPage",
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
                              "Berat",
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
                              "Sensor",
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
                              "dateAndTime",
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
                          _buildTableRow(0, "12 Kg", "1", "23 April 2024, 14:00"),
                          _buildTableRow(1, "13 Kg", "2", "23 April 2024, 14:01"),
                          _buildTableRow(2, "14 Kg", "3", "23 April 2024, 14:02"),
                          _buildTableRow(3, "15 Kg", "4", "23 April 2024, 14:03"),
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

  Widget _buildTableRow(int index, String berat, String sensor, String dateAndTime) {
    // Menentukan warna berdasarkan indeks ganjil atau genap
    Color rowColor = (index % 2 == 0) ? Color(0xFF274155) : Color(0xFF6A96AB);

    return Container(
      color: rowColor, 
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(berat),
          _buildTableCell(sensor),
          _buildTableCell(dateAndTime),
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
