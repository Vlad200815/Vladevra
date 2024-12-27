import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse("https://web.telegram.org/k/#@flutternood");

    Future<void> launchTelegramUrl() async {
      if (!await launchUrl(url)) {
        throw Exception("Could not launch $url");
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/me.png', // Replace with your image path
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Image.asset(
                    "assets/money.png",
                    scale: 2,
                  ),
                  Text(
                    "VLADEVRA",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 125, 4),
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 70),
                  Text(
                    "Будь в курсі!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Text(
                "Це просто крутий проект. Як що ви маєте пропозиці щодо покращення програми, пишіть мені в телеграм",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await launchTelegramUrl();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.telegram,
                          color: Colors.blue,
                          size: 60,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Наш телеграм канал",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
