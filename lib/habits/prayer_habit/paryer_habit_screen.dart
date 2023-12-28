import 'dart:collection';
import 'package:habo/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:habo/habits/calendar_column.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/model/habit_data.dart';

class PrayerHabitsScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Routes.prayerHabitPath,
      key: ValueKey(Routes.prayerHabitPath),
      child: const PrayerHabitsScreen(),
    );
  }

  const PrayerHabitsScreen({
    super.key,
  });

  @override
  State<PrayerHabitsScreen> createState() => _PrayerHabitsScreenState();
}

class _PrayerHabitsScreenState extends State<PrayerHabitsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prayer',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,

      ),
      body: CalendarColumn(
        habits: [
          Habit(habitData:HabitData(
            id: 1,
            position: 0,
            title: 'Fajar',
            twoDayRule: false,
            cue: 'Alarm',
            reward: 'Reward',
            sanction: 'Sanction',
            showReward: true,
            accountant: "",
            advanced: false,
            events: SplayTreeMap<DateTime, List>(),
            notification: true,
            notTime: const TimeOfDay(hour: 0, minute: 1),
            routine: 'Routine',
            showSanction: true,
            type: 'Prayer',
          )),
        ],
      ),

    );
  }

}
