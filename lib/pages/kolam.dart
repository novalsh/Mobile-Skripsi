import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/jadwal_model.dart';
import 'package:skripsi_mobile/utils/secure_storage.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../services/jadwal_service.dart';

class KolamPage extends StatefulWidget {
  const KolamPage({super.key});

  @override
  State<KolamPage> createState() => _KolamPageState();
}

class _KolamPageState extends State<KolamPage> {
  final JadwalService apiService = JadwalService();
  late Future<List<JadwalModel>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _showFormDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274155),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Update Target',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                        future: _dataFuture,
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

  Widget _buildTableRow(int index, String description, String weight,
      String onStart, String TotalWeight) {
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
      return DateFormat('d-M-y').format(date);
    } catch (e) {
      return dateString;
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
      List<JadwalModel> data = await apiService.fetchFoodFishData();
      data.sort((a, b) =>
          DateTime.parse(b.onStart).compareTo(DateTime.parse(a.onStart)));
      return data;
    } catch (e) {
      print('Error occurred while fetching data: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }

  void _showFormDialog(BuildContext context) {
    final TextEditingController targetWeightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update TargetWeight"),
          content: TextField(
            controller: targetWeightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter TargetWeight (grams)",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double? targetWeight = double.tryParse(targetWeightController.text);
                if (targetWeight != null) {
                  Navigator.of(context).pop();
                  _sendTargetWeight(targetWeight, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid input")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendTargetWeight(double targetWeight, BuildContext context) async {
    try {
      await apiService.updateTargetWeight(targetWeight);
      print("TargetWeight updated successfully.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("TargetWeight updated successfully")),
        );
        // Refresh data after successful update
        setState(() {
          _dataFuture = _fetchData();
        });
      }
    } catch (e) {
      print("Failed to update TargetWeight: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update TargetWeight: $e")),
        );
        // Refresh data even if update fails
        setState(() {
          _dataFuture = _fetchData();
        });
      }
    }
  }
}