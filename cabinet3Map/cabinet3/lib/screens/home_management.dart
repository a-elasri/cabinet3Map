import 'package:flutter/material.dart';
import 'package:cabinet3/screens/cabinets_map.dart';
import 'package:cabinet3/screens/cabinets_table.dart';

class HomeManagement extends StatefulWidget {
  const HomeManagement({Key? key}) : super(key: key);

  @override
  State<HomeManagement> createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  final List<Widget> _pages = [
    const CabinetsMap(),
    const CabinetsTable()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'Cabinet Maps'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined), label: 'Cabinet Table'),
        ],
      ),
    );
  }
}
