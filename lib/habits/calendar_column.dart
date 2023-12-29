import 'package:flutter/material.dart';
import 'package:habo/habits/calendar_header.dart';
import 'package:habo/habits/empty_list_image.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/habits/habits_manager.dart';
import 'package:provider/provider.dart';

class CalendarColumn extends StatelessWidget {
  final bool isPrayer;
  const CalendarColumn({super.key, this.isPrayer = false,});

  @override
  Widget build(BuildContext context) {
    List<Habit> calendars = isPrayer? Provider.of<HabitsManager>(context).getPrayerHabits  :   Provider.of<HabitsManager>(context).getAllHabits;
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: CalendarHeader(),
        ),
        Expanded(
          child: (calendars.isNotEmpty)
              ? ReorderableListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 120),
                  children: calendars
                      .map(
                        (index) => Container(
                          key: ObjectKey(index),
                          child: index,
                        ),
                      )
                      .toList(),
                  onReorder: (oldIndex, newIndex) {
                    Provider.of<HabitsManager>(context, listen: false)
                        .reorderList(oldIndex, newIndex);
                  },
                )
              : const EmptyListImage(),
        ),
      ],
    );
  }
}
