import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:studyapp/constraints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class toDoPage extends StatefulWidget {
  const toDoPage({super.key});

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  final _box = Hive.box('todoBox');
  final TextEditingController _controller = TextEditingController();
  String selectedPriority = 'Low';

  
  void _editTask(int index, double h, double w) {
    final task = _box.getAt(index) as Map;

    _controller.text = task['task'];
    selectedPriority = task['priority']; // dropdown'ın doğru çalışması için

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: SizedBox(
          height: h,
          width: w,
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: "Task"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['Low', 'Medium', 'High'].map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level[0].toUpperCase() + level.substring(1)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedPriority = val);
                },
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newText = _controller.text.trim();

              if (newText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun.")),
                );
                return;
              }

              final oldMap = {
                'task': task['task'],
                'priority': task['priority'],
              };

              final newMap = {
                'task': newText,
                'priority': selectedPriority,
              };

              try {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  final userRef =
                      FirebaseFirestore.instance.collection('users').doc(uid);

                  // Önce Firestore'dan eski task'ı sil
                  await userRef.update({
                    'todoList': FieldValue.arrayRemove([oldMap])
                  });

                  // Sonra yeni task'ı ekle
                  await userRef.update({
                    'todoList': FieldValue.arrayUnion([newMap])
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Firestore update error: $e")),
                );
              }

              //Hive should be updated in the last
              _box.putAt(index, newMap);

              _controller.clear();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) async {
    final task = _box.getAt(index) as Map;

    final taskMap = {
      'task': task['task'],
      'priority': task['priority'],
    };

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

        await userRef.update({
          'todoList': FieldValue.arrayRemove([taskMap]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firestore delete error: $e")),
      );
    }

    _box.deleteAt(index);
    setState(() {});
  }

  void _showAddDialog() {
    selectedPriority = 'Low';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: SizedBox(
            height: 150,
            width: 200,
            child: Column(
              children: [
                TextField(controller: _controller),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  items: ['Low', 'Medium', 'High'].map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level[0].toUpperCase() + level.substring(1)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedPriority = val);
                  },
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
              ],
            )),
        actions: [
          TextButton(
            onPressed: () async {
              if (_controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun.")),
                );
                return;
              }
              _box.add({
                'task': _controller.text.trim(),
                'priority': selectedPriority,
              });

              // Add tasks to Firestore
              try {
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'todoList': FieldValue.arrayUnion([
                      {
                        'task': _controller.text.trim(),
                        'priority': selectedPriority,
                      }
                    ]),
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Firestore adding error: $e")),
                );
              }

              _controller.clear();
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

    final tasks = _box.values.toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text(
          "To Do List",
          style: TextStyle(
              color: textfieldColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = _box.getAt(index) as Map;
            final text = task['task'];
            final priority = task['priority'];

            Color borderColor = Colors.blueAccent;
            if (priority == 'High') borderColor = Colors.red;
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
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () =>
                        _editTask(index, screenHeight / 6, screenWidth * 0.9),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
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
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
