import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyapp/LogInPage.dart';
import 'package:studyapp/connectivity_service.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  final todoBox = await Hive.openBox('todoBox');
  final mylibraryBox = await Hive.openBox('mylibrary');
  await Hive.openBox('pendingTodoSync');
  await Hive.openBox('pendingLibrarySync');
  await todoBox.clear();
  await mylibraryBox.clear();
  ConnectivityService().startMonitoring();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInPage(),
    );
  }
}
