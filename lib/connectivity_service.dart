import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  late final StreamSubscription _subscription;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        await _syncPendingTodos();
        await _syncPendingLibrary();
      }
    });
  }

  Future<void> dispose() async {
    await _subscription.cancel();
  }

  Future<void> _syncPendingTodos() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final box = Hive.box('pendingTodoSync');
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    for (int i = 0; i < box.length; i++) {
      final task = box.getAt(i);
      try {
        await userRef.update({
          'todoList': FieldValue.arrayUnion([task])
        });
        box.deleteAt(i);
        i--;
      } catch (_) {
        break;
      }
    }
  }

  Future<void> _syncPendingLibrary() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final box = Hive.box('pendingLibrarySync');
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    for (int i = 0; i < box.length; i++) {
      final book = box.getAt(i);
      try {
        await userRef.update({
          'myLibrary': FieldValue.arrayUnion([book])
        });
        box.deleteAt(i);
        i--;
      } catch (_) {
        break;
      }
    }
  }
}
