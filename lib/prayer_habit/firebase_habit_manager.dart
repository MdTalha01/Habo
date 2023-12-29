import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/model/prayer_habo_model.dart';

class FirebaseHabitManager extends ChangeNotifier {
  final PrayerHaboModel  _haboModel = PrayerHaboModel();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late List<Habit> prayerHabits = [];

  void initialize() async {
    await initModel();
    await Future.delayed(const Duration(seconds: 5));
    notifyListeners();
  }
  initModel() async {
    prayerHabits = await _haboModel.getPrayerHabits();
    notifyListeners();
  }

  List<Habit> get getPrayerHabits {
    return prayerHabits;
  }

  Future<int> insertHabit(Habit habit) async {
    try {
      final data = await _firestore
          .collection('habits').where('title', isEqualTo: habit.habitData.title)
          .get();
      if (data.docs.isEmpty) {
        await _firestore
            .collection('habits')
            .add({}).then((value) {
              habit.habitData.fId = value.id;
          _firestore
              .collection('habits')
              .doc(value.id)
              .update(habit.habitData.toMap());
        });
        return 1;
      }
      return 2;
    }
    catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
    return 0;
  }

  addEvent(String id, DateTime dateTime, List event) {
    _haboModel.insertEvent(id, dateTime, event);
  }

  void deleteEvent(String id, DateTime date) {
    _haboModel.deleteEvent(id, date);

  }
}
