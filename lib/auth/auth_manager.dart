import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthManager extends ChangeNotifier {
   final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthManager({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  void initialize() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        signIn().then(
          (userCredential) => setFirebaseFireStore(userCredential.user!.uid),
        );
      } else {
        setFirebaseFireStore(user.uid);
      }
    });
    notifyListeners();
  }

  void setFirebaseFireStore(String uid) {
    _firestore.collection('user_habits').doc(uid).get().then((user) {
      if (!user.exists) {
        _firestore.collection('user_habits').doc('fajar').set(
          {
            'habits': [
              "fajar",
            ],
          },
        );
    }
  });
  }

  Future<UserCredential> signIn() async {
    return  await _auth.signInAnonymously();
  }

}