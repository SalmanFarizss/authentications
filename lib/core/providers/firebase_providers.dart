import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final fireStoreProvider=Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref)=>FirebaseAuth.instance);
final storageProvider = Provider((ref)=>FirebaseStorage.instance);
// final authProvider = Provider((ref)=>FirebaseAuth.instance);
