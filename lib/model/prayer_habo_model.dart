import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:habo/constants.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/model/habit_data.dart';

class PrayerHaboModel {
  final CollectionReference db =
      FirebaseFirestore.instance.collection('events');

  Future<void> insertEvent(String id, DateTime date, List event) async {
    try {
      db.doc(id).set({
        'h_id': id,
        'dateTime': date.toString(),
        'dayType': event[0].index,
        'comment': event[1],
      });
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }
  Future<List<Habit>> getPrayerHabits() async {
    List<Habit> result = [];

    await FirebaseFirestore.instance
        .collection('habits')
        .where('type', isEqualTo: 'prayer') // Update the query here
        .get()
        .then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        HabitData h = HabitData.fromMap(doc.data());

        await FirebaseFirestore.instance
            .collection('events')
            .where('h_id', isEqualTo: doc.id)
            .get()
            .then((eventQuerySnapshot) {
          if (eventQuerySnapshot.docs.isNotEmpty) {
            Map<DateTime, List<dynamic>> resultMap = {};
            for (var element in eventQuerySnapshot.docs) {
              DateTime dateTime = DateTime.parse(element['dateTime'] as String);
              DayType dayType = DayType.values[element['dayType'] as int];
              String comment = element['comment'] as String;
              resultMap[dateTime] = [dayType, comment];
            }
            h.events = SplayTreeMap.from(resultMap);

          }
            result.add(Habit(habitData: h));
        });
      }
    });
    return result;
  }
  

  Future<void> deleteEvent(String id, DateTime date) async {
    try {
      await db
          .where('h_id', isEqualTo: id)
          .where('dateTime', isEqualTo: date.toString())
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } catch (_) {
      if (kDebugMode) {
        print(_);
      }
    }
  }
}
