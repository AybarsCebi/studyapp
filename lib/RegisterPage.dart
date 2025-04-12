import 'package:flutter/material.dart';
import 'package:studyapp/LogInPage.dart';
import 'package:studyapp/Navbar.dart';
import 'package:studyapp/constraints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _gender;

  String? _statusMessage;

  Future<void> _selectBirthday() async {
    DateTime? _date = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (_date != null) {
      setState(() {
        _birthdayController.text = _date.toString().split(" ")[0];
      });
    }
  }

  //Başka kontroller için bu kısım oluşturulmuştur
  bool isValidEmail(String email) {
    return email.contains('@');
  }

  Future<void> register() async {
    if (_emailController.text.isEmpty || !isValidEmail(_emailController.text)) {
      setState(() {
        _statusMessage = "Please enter a valid email address.";
      });
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': _usernameController.text.trim(), // Kullanıcı adını al
        'email': _emailController.text.trim(),
        'gender': _gender,
        'birthday': Timestamp.fromDate(
          DateFormat('yyyy-MM-dd').parse(_birthdayController.text.trim()),
        ),
        'productivityPoint': 0,
      });

      debugPrint("🎉 Kullanıcı başarıyla kayıt oldu ve Firestore'a eklendi!");
      setState(() {
        _statusMessage = "Registration successful!";
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Navbar(),
          ));
    } catch (e) {
      setState(() {
        _statusMessage = "Error: $e";
      });
    }

    debugPrint(_statusMessage);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth / 15, screenHeight / 15,
              screenWidth / 15, screenHeight / 15),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Create New Account",
                  style: TextStyle(
                      color: textfieldColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt),
                  iconSize: 50,
                  color: textfieldColor,
                ),
                SizedBox(height: screenHeight / 20),
                TextField(
                  style: TextStyle(color: backgroundColor),
                  controller: _usernameController,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      fillColor: textfieldColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: screenHeight / 100),
                TextField(
                  style: TextStyle(color: backgroundColor),
                  controller: _birthdayController,
                  readOnly: true,
                  onTap: _selectBirthday,
                  decoration: InputDecoration(
                      hintText: 'Birthday',
                      fillColor: textfieldColor,
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: screenHeight / 100),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: textfieldColor,
                    filled: true,
                    hintText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textfieldColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: textfieldColor),
                    ),
                  ),
                  value: _gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: ['Female', 'Male', 'Other'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                SizedBox(height: screenHeight / 100),
                TextField(
                  style: TextStyle(color: backgroundColor),
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'email',
                      fillColor: textfieldColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: screenHeight / 100),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Create a password',
                    fillColor: textfieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: screenHeight / 100),
                Text(
                  "or Register with",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textfieldColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: screenWidth / 30,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(textfieldColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Google Account",
                        style: TextStyle(color: backgroundColor),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(textfieldColor),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Apple Account",
                        style: TextStyle(color: backgroundColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight / 50),
                FilledButton(
                  onPressed: register,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(textfieldColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(color: backgroundColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you have an account,",
                      style: TextStyle(color: textfieldColor, fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        // Register sayfasına yönlendirme kodu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LogInPage()), // RegisterPage ile ilgili yönlendirme
                        );
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textfieldColor, // Rengi mavi yapabilirsiniz
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
