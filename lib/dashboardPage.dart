import 'package:flutter/material.dart';
import 'pages/history.dart';
import 'pages/kolam.dart';
import 'pages/dashboard.dart';
import 'pages/sensor.dart';
import 'pages/users.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 2; // Default page is Dashboard
  final List<Widget> _pages = [
    const HistoryPage(),
    const KolamPage(),
    const MainDashboardPage(),
    const SensorPage(),
    const UsersPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           Color(0xFF1F2937), // Biru cerah
      //           Color(0xFF1F2937), // Ungu
      //         ],
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //       ),
      //     ),
      //   ),
      //   title: Text(
      //     [
      //       'History',
      //       'Jadwal',
      //       'Dashboard',
      //       'Alat',
      //       'Users',
      //     ][_selectedIndex],
      //     style: const TextStyle(
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6C5CE7),
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFF1F2937),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Alat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
