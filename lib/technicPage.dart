import 'package:flutter/material.dart';
import 'package:studyapp/constraints.dart';

class technicPage extends StatefulWidget {
  const technicPage({super.key});

  @override
  State<technicPage> createState() => _technicPageState();
}

class _technicPageState extends State<technicPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth / 30, screenHeight / 50,
              screenWidth / 30, screenHeight / 50),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 40,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Work Hard",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: textfieldColor),
                  )),
              SizedBox(
                height: screenHeight / 50,
              ),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad",
                style: TextStyle(fontSize: 18, color: textfieldColor),
              ),
              SizedBox(
                height: screenHeight / 10,
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: screenHeight / 6.5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/feynman.png"),
                          fit: BoxFit.cover,
                          opacity: 0.8),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      "Feynman Technic",
                      style: TextStyle(
                          fontSize: 28,
                          color: backgroundColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  height: screenHeight / 6.5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/pomodoro.png"),
                          fit: BoxFit.cover,
                          opacity: 0.8),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      "Pomodoro Technic",
                      style: TextStyle(
                          fontSize: 28,
                          color: backgroundColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
