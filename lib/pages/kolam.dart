import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/jadwal_model.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';
import 'package:intl/intl.dart';
import '../services/jadwal_service.dart';

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
                      child: Row(
                        children: [
                          _buildHeaderCell("Description"),
                          _buildHeaderCell("Weight"),
                          _buildHeaderCell("Start Time"),
                          _buildHeaderCell("Target"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<JadwalModel>>(
                        future: _fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No data available.'));
                          } else {
                            List<JadwalModel> data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return _buildTableRow(
                                  index,
                                  data[index].description,
                                  _formatWeight(data[index].weight),
                                  data[index].onStart,
                                  _formatWeight(data[index].TargetWeight),
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

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTableRow(
      int index, String description, String weight, String onStart, String TotalWeight) {
    Color rowColor =
        (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(description),
          _buildTableCell(weight),
          _buildTableCell(_formatDate(onStart)),
          _buildTableCell(TotalWeight),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.3), width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

String _formatDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('d-M-y').format(date); // Menggunakan format 'd M y'
  } catch (e) {
    return dateString; // Jika parsing gagal, kembalikan string asli
  }
}

    String _formatWeight(double weight) {
    if (weight >= 1000) {
      return "${(weight / 1000).toStringAsFixed(2)} kg";
    }
    return "${weight.toStringAsFixed(2)} g";
  }

  Future<List<JadwalModel>> _fetchData() async {
    try {
      JadwalService apiService = JadwalService();
      List<JadwalModel> data = await apiService.fetchFoodFishData();

      // Sorting data berdasarkan waktu terbaru
      data.sort((a, b) =>
          DateTime.parse(b.onStart).compareTo(DateTime.parse(a.onStart)));

      return data;
    } catch (e) {
      print('Error occurred while fetching data: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }
}
