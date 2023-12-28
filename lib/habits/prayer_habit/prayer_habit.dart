import 'package:flutter/material.dart';
import 'package:habo/constants.dart';
import 'package:habo/generated/l10n.dart';
import 'package:habo/habits/calendar_header.dart';
import 'package:habo/helpers.dart';
import 'package:habo/settings/settings_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habo/extensions.dart';

class PrayerHabit extends StatefulWidget {
  const PrayerHabit({super.key, });


  @override
  State<PrayerHabit> createState() => PrayerHabitState();
}

class PrayerHabitState extends State<PrayerHabit> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool _showMonth = false;
  String _actualMonth = '';
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  showRewardNotification(date) {
    // if (isSameDay(date, DateTime.now()) &&
    //     widget.PrayerHabitData.showReward &&
    //     widget.PrayerHabitData.reward != '') {
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: const Duration(seconds: 2),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       content: Text(
    //         '${S.of(context).congratulationsReward}\n${widget.PrayerHabitData.reward}',
    //         textAlign: TextAlign.center,
    //         style: const TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    // }
  }

  showSanctionNotification(date) {
    // if (isSameDay(date, DateTime.now()) &&
    //     widget.PrayerHabitData.showSanction &&
    //     widget.PrayerHabitData.sanction != '') {
    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: const Duration(seconds: 2),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       content: Text(
    //         '${S.of(context).ohNoSanction}\n${widget.PrayerHabitData.sanction}',
    //         textAlign: TextAlign.center,
    //         style: const TextStyle(color: Colors.white),
    //       ),
    //       backgroundColor:
    //       Provider.of<SettingsManager>(context, listen: false).failColor,
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
    // }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setSelectedDay(selectedDay);
  }

  setSelectedDay(DateTime selectedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = selectedDay;
        reloadMonth(selectedDay);
      });
    }
  }

  reloadMonth(DateTime selectedDay) {
    _showMonth = (_calendarFormat == CalendarFormat.month);
    _actualMonth = DateFormat('yMMMM', Intl.getCurrentLocale())
        .format(selectedDay)
        .capitalize();
  }

  _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
        reloadMonth(_selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CalendarHeader(),
            const Text(
              "Fajar",
              style:  TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
            if (_showMonth &&
                Provider
                    .of<SettingsManager>(context)
                    .getShowMonthName)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(_actualMonth),
              ),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime.now(),
              headerVisible: false,
              currentDay: DateTime.now(),
              availableCalendarFormats: {
                CalendarFormat.month: S
                    .of(context)
                    .month,
                CalendarFormat.week: S
                    .of(context)
                    .week,
              },
              // eventLoader: ,
              calendarFormat: _calendarFormat,
              daysOfWeekVisible: false,
              onFormatChanged: _onFormatChanged,
              onPageChanged: setSelectedDay,
              onDaySelected: _onDaySelected,
              startingDayOfWeek:
              Provider
                  .of<SettingsManager>(context)
                  .getWeekStartEnum,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  return PrayerButton(
                    id: 0,
                    date: date,
                  );
                },

                todayBuilder: (context, date, _) {
                  return PrayerButton(
                    id: 0,
                    date: date,
                  );
                },
                disabledBuilder: (context, date, _) {
                  return PrayerButton(
                    id: 0,
                    date: date,
                  );
                },
                outsideBuilder: (context, date, _) {
                  return PrayerButton(
                    id: 0,
                    date: date,
                  );
                },

                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return _buildEventsMarker(date, events);
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AspectRatio(
      aspectRatio: 1,
      child: IgnorePointer(
        child: Stack(children: [
          (events[0] != DayType.clear)
              ? Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: events[0] == DayType.check
                  ? Provider
                  .of<SettingsManager>(context, listen: false)
                  .checkColor
                  : events[0] == DayType.fail
                  ? Provider
                  .of<SettingsManager>(context,
                  listen: false)
                  .failColor
                  : Provider
                  .of<SettingsManager>(context,
                  listen: false)
                  .skipColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: events[0] == DayType.check
                ? const Icon(
              Icons.check,
              color: Colors.white,
            )
                : events[0] == DayType.fail
                ? const Icon(
              Icons.close,
              color: Colors.white,
            )
                : const Icon(
              Icons.last_page,
              color: Colors.white,
            ),
          )
              : Container(),
          (events[1] != null && events[1] != '')
              ? Container(
            alignment: const Alignment(1.0, 1.0),
            padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 2.0),
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              elevation: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: HaboColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
              : Container(),
        ]),
      ),
    );
  }


}

class PrayerButton extends StatelessWidget {
   PrayerButton({
    super.key,
    required date,
    this.color,
    this.child,
    required this.id,
    })
      : date = transformDate(date);

  final int id;
  final DateTime date;
  final Color? color;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .secondary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          date.day.toString(),
        ),
      ),
    );
  }
}
