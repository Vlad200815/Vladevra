import 'package:flutter/material.dart';
import 'package:vladevra/screens/home_screen.dart';
import 'package:vladevra/screens/settings_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomBarIndex == 0 ? HomeScreen() : SettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        onTap: (value) {
          setState(() {
            bottomBarIndex = value;
          });
        },
        currentIndex: bottomBarIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.currency_exchange_outlined,
            ),
            label: "Курси валют",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Настройки",
          ),
        ],
      ),
    );
  }
}
