import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyapp/Navbar.dart';
import 'package:studyapp/RegisterPage.dart';
import 'package:studyapp/constraints.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _LoginEmailController = TextEditingController();
  final TextEditingController _LoginPasswordController =
      TextEditingController();
  String? _statusMessage;

  Future<void> logIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _LoginEmailController.text.trim(),
        password: _LoginPasswordController.text.trim(),
      );
      setState(() {
        _statusMessage = "Log In successful!";
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _statusMessage = "Log out successful!";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Center(
            child: Column(
              children: [
                
                SizedBox(height: screenHeight / 3),
                TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _LoginEmailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: textfieldColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: screenHeight / 80),
                TextField(
                  controller: _LoginPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: textfieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: screenHeight / 80),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textfieldColor,
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  onPressed: () {
                    logIn();
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(color: backgroundColor, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you do not have an account,",
                      style: TextStyle(color: textfieldColor, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        // Register sayfasına yönlendirme kodu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterPage()), // RegisterPage ile ilgili yönlendirme
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textfieldColor, // Rengi mavi yapabilirsiniz
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _statusMessage ?? '',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
