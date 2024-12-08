import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/jadwal_model.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';
import '../services/jadwal_service.dart';
import '../models/jadwal_model.dart';

class KolamPage extends StatelessWidget {
  const KolamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final JadwalService apiService = JadwalService();

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
                              "Weight",
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
                              "Start Time",
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
                    // Fetching data dari API
                    Expanded(
                      child: FutureBuilder<List<JadwalModel>>(
                        future: _fetchData(), // Memanggil fungsi _fetchData untuk mendapatkan data
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No data available.'));
                          } else {
                            List<JadwalModel> data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return _buildTableRow(
                                  index,
                                  data[index].weight.toString(),   // Tampilkan weight
                                  data[index].sensor.toString(),  // Tampilkan sensor_id
                                  data[index].onStart,             // Tampilkan onStart
                                );
                              },
                            );
                          }
                        },
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

  Widget _buildTableRow(int index, String weight, String sensor, String onStart) {
    
    Color rowColor = (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(weight),   
          _buildTableCell(sensor),   
          _buildTableCell(onStart),  
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

  Future<List<JadwalModel>> _fetchData() async {
    String? token = await SecureStorage.getToken(); 

    if (token == null || token.isEmpty) {
      throw Exception('No token found, please log in again.'); 
    }

    JadwalService apiService = JadwalService();
    return apiService.fetchFoodFishData(); 
  }
}
