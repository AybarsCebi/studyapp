import 'package:flutter/material.dart';
import 'package:studyapp/LeaderboardPage.dart';
import 'package:studyapp/ProfilePage.dart';
import 'package:studyapp/constraints.dart';
import 'package:studyapp/myBooksPage.dart';
import 'package:studyapp/technicPage.dart';
import 'package:studyapp/toDoPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth/8, 0, screenWidth/8, 0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: screenHeight / 20),

                // Başlık
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'One day, ',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'day one!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight / 20),

                // 2x2 Kare Butonlar
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth / 40,
                  mainAxisSpacing: screenHeight / 80,
                  shrinkWrap: true,
                  children: [
                    buildSquareBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  technicPage()), 
                        );
                      },
                      gradient:
                          LinearGradient(colors: [Colors.purple, Colors.blue]),
                      icon: Icons.work_history, // Sembol yerine placeholder
                    ),
                    buildSquareBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  myBooksPage()), // RegisterPage ile ilgili yönlendirme
                        );
                      },
                      color: Colors.red.shade700,
                      icon: Icons.menu_book,
                    ),
                    buildSquareBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  toDoPage()), // RegisterPage ile ilgili yönlendirme
                        );
                      },
                      color: Colors.greenAccent.shade700,
                      icon: Icons.bar_chart,
                    ),
                    buildSquareBox(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage()), // RegisterPage ile ilgili yönlendirme
                        );
                      },
                      color: Colors.yellow.shade400,
                      child: const Text(
                        "Notes",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight/4,),
                // Alt Bilgi ikonu, alignment çalışmıyor
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.info_outline,
                        color: Colors.cyan, size: 40),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  // boyut ayarı yapılacak
  Widget buildSquareBox({
    required VoidCallback onTap,
    Color? color,
    Gradient? gradient,
    IconData? icon,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: child ??
              Icon(
                icon,
                size: 60,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
