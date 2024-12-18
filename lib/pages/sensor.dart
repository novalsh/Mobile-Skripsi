import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/sensor_model.dart';
import 'package:skripsi_mobile/services/sensor_services.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  Future<String?> _getBranchId() async {
    return await SecureStorage().getBranchId();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 150, 171),
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: _getBranchId(),
          builder: (context, branchIdSnapshot) {
            if (branchIdSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!branchIdSnapshot.hasData ||
                branchIdSnapshot.data == null) {
              return const Center(
                child: Text(
                  'Branch ID not found',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            final branchId = branchIdSnapshot.data!;

            return Column(
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
                        // Header tabel
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
                                  "Latitude",
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
                                  "Longitude",
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

                        // Isi tabel menggunakan FutureBuilder
                        Expanded(
                          child: FutureBuilder<String?>(
                            future: _getBranchId(),
                            builder: (context, branchIdSnapshot) {
                              if (branchIdSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (!branchIdSnapshot.hasData ||
                                  branchIdSnapshot.data == null) {
                                return const Center(
                                  child: Text(
                                    'Branch ID not found',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }

                              final branchId = branchIdSnapshot.data!;

                              return FutureBuilder<List<SensorModel>>(
                                future: SensorService().fetchSensorData(
                                    branchId), // Pastikan branchId digunakan di sini
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${snapshot.error}',
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }

                                  final sensors = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: sensors.length,
                                    itemBuilder: (context, index) {
                                      final sensor = sensors[index];
                                      return _buildTableRow(
                                        index,
                                        sensor.code,
                                        sensor.latitude.toString(),
                                        sensor.longitude.toString(),
                                        sensor.isOn,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableRow(int index, String code, String latitude,
      String longitude, bool isOnline) {
    Color rowColor =
        (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(code),
          _buildTableCell(latitude),
          _buildTableCell(longitude),
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

extension on SecureStorage {
  getBranchId() {}
}
