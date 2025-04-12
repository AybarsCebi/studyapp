import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:studyapp/constraints.dart';

class myBooksPage extends StatefulWidget {
  const myBooksPage({super.key});

  @override
  State<myBooksPage> createState() => _myBooksPageState();
}

class _myBooksPageState extends State<myBooksPage> {
  final myBooksBox = Hive.box('mylibrary');
  final TextEditingController bookName = TextEditingController();
  final TextEditingController pageNumber = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController finishDate = TextEditingController();

  Future<void> selectStartDay() async {
    DateTime? _date = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (_date != null) {
      setState(() {
        startDate.text = _date.toString().split(" ")[0];
      });
    }
  }

  Future<void> selectFinishDay() async {
    DateTime? _date = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (_date != null) {
      setState(() {
        finishDate.text = _date.toString().split(" ")[0];
      });
    }
  }

  void editBook(int index, double h, double w) {
    final book = myBooksBox.getAt(index) as Map;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Book"),
        content: SizedBox(
            height: h,
            width: w,
            child: Column(
              children: [
                TextField(
                  controller: bookName,
                  decoration: InputDecoration(hintText: book['bookName']),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pageNumber,
                  decoration: InputDecoration(hintText: book['pageNumber']),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: startDate,
                  readOnly: true,
                  onTap: selectStartDay,
                  decoration: InputDecoration(
                    hintText: "Start Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: finishDate,
                  readOnly: true,
                  onTap: selectFinishDay,
                  decoration: InputDecoration(
                    hintText: "Finish Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () async {
              if (bookName.text.trim().isEmpty ||
                  pageNumber.text.trim().isEmpty ||
                  startDate.text.trim().isEmpty ||
                  finishDate.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun.")),
                );
                return;
              }
              if (DateFormat('yyyy-MM-dd')
                  .parse(finishDate.text.trim())
                  .isBefore(
                      DateFormat('yyyy-MM-dd').parse(startDate.text.trim()))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Finish date cannot be before start date.")),
                );
                return;
              }

              final oldMap = {
                'bookName' : book['bookName'],
                'pageNumber' : book['pageNumber'],
                'startDate' : book['startDate'],
                'finishDate' : book['finishDate']
              };
              final newMap = {
                'bookName' : bookName.text.trim(),
                'pageNumber' : int.tryParse(pageNumber.text.trim()),
                'startDate' : DateFormat('yyyy-MM-dd').parse(startDate.text.trim()),
                'finishDate' : DateFormat('yyyy-MM-dd').parse(finishDate.text.trim())
              };
              try {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  final userRef =
                      FirebaseFirestore.instance.collection('users').doc(uid);

                  // Önce Firestore'dan eski task'ı sil
                  await userRef.update({
                    'myLibrary': FieldValue.arrayRemove([oldMap])
                  });

                  // Sonra yeni task'ı ekle
                  await userRef.update({
                    'myLibrary': FieldValue.arrayUnion([newMap])
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Firestore update error: $e")),
                );
              }
              
              myBooksBox.putAt(index, newMap);
              bookName.clear();
              pageNumber.clear();
              startDate.clear();
              finishDate.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteBook(int index) async {
    final book = myBooksBox.getAt(index) as Map;

    final bookMap = {
      'bookName': book['bookName'],
      'pageNumber': book['pageNumber'],
      'startDate' : book['startDate'],
      'finishDate' : book['finishDate']
    };

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

        await userRef.update({
          'myLibrary': FieldValue.arrayRemove([bookMap]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firestore delete error: $e")),
      );
    }
    myBooksBox.deleteAt(index);
    setState(() {});
  }

  void addBook(double h, double w) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Book"),
        content: SizedBox(
            height: h,
            width: w,
            child: Column(
              children: [
                TextField(
                  controller: bookName,
                  decoration: InputDecoration(hintText: "Book Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pageNumber,
                  decoration: InputDecoration(hintText: "Page Number"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: startDate,
                  readOnly: true,
                  onTap: selectStartDay,
                  decoration: InputDecoration(
                    hintText: "Start Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: finishDate,
                  readOnly: true,
                  onTap: selectFinishDay,
                  decoration: InputDecoration(
                    hintText: "Finish Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () async {
              if (bookName.text.trim().isEmpty ||
                  pageNumber.text.trim().isEmpty ||
                  startDate.text.trim().isEmpty ||
                  finishDate.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun.")),
                );
                return;
              }
              myBooksBox.add({
                'bookName': bookName.text.trim(),
                'pageNumber': int.tryParse(pageNumber.text.trim()),
                'startDate':
                    DateFormat('yyyy-MM-dd').parse(startDate.text.trim()),
                'finishDate':
                    DateFormat('yyyy-MM-dd').parse(finishDate.text.trim()),
              });

              // Add books to Firestore
              try {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'myLibrary': FieldValue.arrayUnion([
                      {
                        'bookName': bookName.text.trim(),
                        'pageNumber': int.tryParse(pageNumber.text.trim()),
                        'startDate': DateFormat('yyyy-MM-dd')
                            .parse(startDate.text.trim()),
                        'finishDate': DateFormat('yyyy-MM-dd')
                            .parse(finishDate.text.trim())
                      }
                    ]),
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Firestore adding error: $e")),
                );
              }

              bookName.clear();
              pageNumber.clear();
              startDate.clear();
              finishDate.clear();

              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final books = myBooksBox.values.toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: textfieldColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          "My Library",
          style: TextStyle(
              color: textfieldColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = myBooksBox.getAt(index) as Map;
            final bookname = book['bookName'];
            final finishdate = book['finishDate'];

            Color borderColor = Colors.blueAccent;

            return Container(
              height: screenHeight/11,
              margin: EdgeInsets.symmetric(vertical: screenHeight / 100),
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 40),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      bookname,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(finishdate),
                    style: TextStyle(color: textfieldColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () =>
                        editBook(index, screenHeight / 2, screenWidth * 0.9),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteBook(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: addTaskColor,
        onPressed: () => addBook(screenHeight / 3, screenWidth * 0.9),
        child: const Icon(Icons.add),
      ),
    );
  }
}
