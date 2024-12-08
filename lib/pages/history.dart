import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
                    "Kolam Page",
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

            // Tombol untuk membuka pop-up form
            // Tombol untuk membuka pop-up form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment
                    .centerRight, // Menempatkan tombol di sebelah kanan
                child: ElevatedButton(
                  onPressed: () {
                    // Tampilkan dialog saat tombol ditekan
                    _showFormDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274155), // Warna tombol hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Add +',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
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
                              "Tanggal",
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
                              "User",
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
                              "Catatan",
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
                          _buildTableRow(0, "23 April 2024", "Admin", "Alat 1",
                              "Branch 1", "Catatan 1"),
                          _buildTableRow(1, "24 April 2024", "Admin", "Alat 2",
                              "Branch 2", "Catatan 2"),
                          _buildTableRow(2, "25 April 2024", "Admin", "Alat 3",
                              "Branch 3", "Catatan 3"),
                          _buildTableRow(3, "26 April 2024", "Admin", "Alat 4",
                              "Branch 4", "Catatan 4"),
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

  Widget _buildTableRow(int index, String tanggal, String user, String sensor,
      String branch, String catatan) {
    // Menentukan warna berdasarkan indeks ganjil atau genap
    Color rowColor = (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(tanggal),
          _buildTableCell(user),
          _buildTableCell(sensor),
          _buildTableCell(branch),
          _buildTableCell(catatan),
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


  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add history"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Tanggal"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "User"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Sensor"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Branch"),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Catatan"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                // Handle submit form logic here
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
