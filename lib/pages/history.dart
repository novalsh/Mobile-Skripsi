import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_model.dart';
import '../services/history_services.dart';
import '../services/sensor_services.dart';
import '../models/sensor_model.dart';
import '../utils/secure_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService apiService = HistoryService();
  final SensorService sensorService = SensorService();
  Future<List<HistoryModel>> _historyDataFuture = Future.value([]);
  Future<List<SensorModel>> _sensorDataFuture = Future.value([]);
  String? branchId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final secureStorage = SecureStorage();
      branchId = await secureStorage.getBranchId();
      if (branchId == null || branchId!.isEmpty) {
        throw Exception("Branch ID not found. Please log in again.");
      }

      setState(() {
        _historyDataFuture = apiService.fetchHistoryDataByToken();
        _sensorDataFuture = sensorService.fetchSensorData(branchId!);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error initializing data: $e")),
      );
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        _historyDataFuture = apiService.fetchHistoryDataByToken();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error refreshing data: $e")),
      );
    }
  }

  void _showFormDialog(BuildContext context) {
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  int? selectedSensorId;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add History"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input Tanggal
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Tanggal",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-ddTHH:mm:ssZ')
                                    .format(selectedDate.toUtc());
                            dateController.text = formattedDate;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Catatan
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: "Catatan"),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Sensor
                  FutureBuilder<List<SensorModel>>(
                    future: _sensorDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                            "Error loading sensors: ${snapshot.error}");
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return const Text("No sensors available.");
                      } else {
                        return DropdownButtonFormField<int>(
                          decoration:
                              const InputDecoration(labelText: "Sensor"),
                          items: snapshot.data!
                              .where((sensor) => sensor.id != 0)
                              .map((sensor) {
                            return DropdownMenuItem<int>(
                              value: sensor.id,
                              child: Text(sensor.code),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSensorId = value;
                            });
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  // Validasi Field
                  if (dateController.text.isEmpty ||
                      noteController.text.isEmpty ||
                      selectedSensorId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Harap isi semua field")),
                    );
                    return;
                  }

                  try {
                    // Ambil user_id dan branch_id
                    final int? userId = await SecureStorage.getUserId();
                    if (userId == null) {
                      throw Exception("User ID not found. Please log in.");
                    }

                    final String? branchId =
                        await SecureStorage().getBranchId();
                    if (branchId == null || branchId.isEmpty) {
                      throw Exception("Branch ID not found. Please log in.");
                    }

                    // Debugging Nilai Field
                    print("DEBUG: sensor_id: $selectedSensorId");
                    print("DEBUG: description: ${noteController.text}");
                    print("DEBUG: date: ${dateController.text}");
                    print("DEBUG: user_id: $userId");
                    print("DEBUG: branch_id: $branchId");

                    // Kirim Data ke Server
                    await apiService.createHistory(
                      sensorId: selectedSensorId!,
                      description: noteController.text,
                      date: dateController.text,
                      userId: userId,
                      branchId: int.parse(branchId),
                    );

                    // Refresh Data
                    _refreshData();

                    // Tutup Dialog
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("History berhasil ditambahkan")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Gagal menambahkan history: $e")),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      );
    },
  );
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
                    "History Page",
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
                    'Add +',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                          _buildHeaderCell("Tanggal"),
                          _buildHeaderCell("Catatan"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<HistoryModel>>(
                        future: _historyDataFuture,
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
                            List<HistoryModel> data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return _buildTableRow(
                                  index,
                                  data[index].date,
                                  data[index].description,
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

  Widget _buildTableRow(int index, String tanggal, String catatan) {
    Color rowColor =
        (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(_formatDate(tanggal)),
          _buildTableCell(catatan),
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
      return DateFormat('d MMMM y').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
