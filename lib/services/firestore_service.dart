import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Menambahkan data pengguna baru ke Firestore
  Future<void> addUser(String uid, String email) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'createdAt': DateTime.now(),
    });
  }

  // Mengambil data pengguna
  Future<DocumentSnapshot> getUser(String uid) async {
    return await userCollection.doc(uid).get();
  }
}
