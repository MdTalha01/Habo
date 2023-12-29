import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/model/habit_data.dart';
import 'package:habo/prayer_habit/firebase_habit_manager.dart';

class AuthManager extends ChangeNotifier {
   final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthManager({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  void initialize() {
    FirebaseHabitManager().insertHabit(Habit(
      habitData: HabitData(
        title: 'fajar',
        showSanction: false,
        routine: "daily",
        notTime: const TimeOfDay(hour: 0, minute: 0),
        notification: false,
        advanced: false,
        cue: "",
        twoDayRule: false,
        position: 0,
        accountant: "",
        reward: "",
        sanction: "",
        showReward: false,
        type: "prayer",
          events: SplayTreeMap<DateTime, List>()
      ),
    ) );
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        signIn().then(
          (userCredential) => setFirebaseFireStore(userCredential.user!.uid),
        );
      }
    });
    notifyListeners();
  }

  void setFirebaseFireStore(String uid) {
    _firestore.collection('habits').get().then(
      (habits) {
        List<String> hbts = habits.docs.map((element) => element.id).toList();
    _firestore.collection('user_habits').doc(uid).get().then((user) {
      if (!user.exists) {
        _firestore.collection('user_habits').doc(uid).set(
          {
            'habits': hbts,
          },
        );
    }
  });
      },
    );
  }

  Future<UserCredential> signIn() async {
    return  await _auth.signInAnonymously();
  }

}