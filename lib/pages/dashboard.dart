import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_mobile/models/jadwal_model.dart';
import 'package:skripsi_mobile/services/jadwal_service.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  bool isAvailable = true; // Status awal toggle
  List<JadwalModel> _jadwalList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJadwalData();
  }

  void _fetchJadwalData() async {
    try {
      JadwalService jadwalService = JadwalService();
      List<JadwalModel> data = await jadwalService.fetchFoodFishData();

      // Konversi waktu ke lokal dan sort berdasarkan waktu terbaru
      data.sort((a, b) {
        DateTime aTime = DateTime.parse(a.onStart).toLocal();
        DateTime bTime = DateTime.parse(b.onStart).toLocal();
        return bTime.compareTo(aTime);
      });

      setState(() {
        _jadwalList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  String _getNextFeedingTime() {
    if (_jadwalList.isEmpty) {
      return "No data"; // Tampilkan pesan jika tidak ada data
    }

    // Cari waktu terakhir
    DateTime? latestTime = _jadwalList
        .map((jadwal) => DateTime.parse(jadwal.onStart))
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // Konversi ke waktu lokal
    DateTime localLatestTime = latestTime.toLocal();

    // Tambahkan 6 jam ke waktu lokal
    DateTime nextFeedingTime = localLatestTime.add(const Duration(hours: 6));

    // Format waktu ke bentuk "HH:mm"
    return DateFormat("HH:mm").format(nextFeedingTime);
  }

  num _getTotalFeed() {
    if (_jadwalList.isEmpty) {
      return 0.0; // Jika tidak ada data, total adalah 0
    }

    // Menjumlahkan semua weight dari jadwal
    return _jadwalList.map((jadwal) => jadwal.weight).reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 106, 150, 171),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 24),

            // Statistik Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    "Pemberian pakan selanjutnya",
                    _getNextFeedingTime(),
                  ),
                  _buildStatCardWithToggle("Pakan yang tersedia"),
                  _buildStatCard(
                    "Pakan yang sudah diberikan",
                    "${_getTotalFeed().toStringAsFixed(2)} Kg", // Menampilkan total pakan
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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
                              "Deskripsi",
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
                              "Pakan",
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
                        ],
                      ),
                    ),
                    // Isi tabel
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _jadwalList.isEmpty
                              ? const Center(
                                  child: Text("Tidak ada data jadwal"))
                              : ListView.builder(
                                  itemCount: _jadwalList.length,
                                  itemBuilder: (context, index) {
                                    JadwalModel jadwal = _jadwalList[index];
                                    return _buildTableRow(
                                      index,
                                      jadwal.onStart,
                                      jadwal.description,
                                      "${jadwal.weight} Kg",
                                      "Sensor ${jadwal.sensor}",
                                    );
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

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 39, 86, 116),
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

  Widget _buildStatCardWithToggle(String title) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green : Colors.red,
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
          Switch(
            value: isAvailable,
            onChanged: (bool value) {
              setState(() {
                isAvailable = value;
              });
            },
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
      int index, String date, String description, String feed, String tool) {
    Color rowColor =
        (index % 2 == 0) ? const Color(0xFF274155) : const Color(0xFF6A96AB);

    // Format tanggal dan jam
    String formattedDate = _formatDateTime(date);

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildTableCell(formattedDate),
          _buildTableCell(description),
          _buildTableCell(feed),
          _buildTableCell(tool),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    try {
      // Parse string menjadi DateTime
      DateTime date = DateTime.parse(dateString);

      // Konversi ke waktu lokal
      DateTime localDate = date.toLocal();

      // Format menjadi 'dd MMMM yyyy HH:mm'
      return DateFormat('dd MMMM yyyy HH:mm').format(localDate);
    } catch (e) {
      // Jika parsing gagal, kembalikan string aslinya
      print("Error parsing date: $e");
      return dateString;
    }
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
