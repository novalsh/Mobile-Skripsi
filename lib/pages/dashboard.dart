import 'package:flutter/material.dart';

class MainDashboardPage extends StatelessWidget {
  const MainDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0D47A1), // Warna biru gelap untuk latar belakang
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('img/profile_picture.png'),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Tambahkan jarak di sini
            const SizedBox(
                height: 24), // Memberikan jarak vertikal sebesar 24px

            // Statistik Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Pemberian pakan selanjutnya", "Jam\n16:00"),
                  _buildStatCard("Pakan yang tersedia", "Kg\n20"),
                  _buildStatCard("Pakan yang sudah diberikan", "Kg\n10"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tabel data
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    // Header tabel
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Tanggal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Jam",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Pakan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Alat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      height: 1,
                    ),
                    // Isi tabel
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        children: [
                          _buildDataRow(
                              "22 April 2024", "12:00", "1.5 Kg", "Alat 1"),
                          _buildDataRow(
                              "23 April 2024", "14:00", "1.2 Kg", "Alat 2"),
                          _buildDataRow(
                              "28 April 2024", "10:00", "2.0 Kg", "Alat 2"),
                          _buildDataRow(
                              "30 April 2024", "08:00", "3.2 Kg", "Alat 3"),
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

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF42A5F5), // Biru terang
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String date, String time, String feed, String tool) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2), // Warna biru
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            feed,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            tool,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
