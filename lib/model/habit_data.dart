import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:habo/constants.dart';

class HabitData {
  HabitData({
    this.id,
    required this.position,
    required this.title,
    required this.twoDayRule,
    required this.cue,
    required this.routine,
    required this.reward,
    required this.showReward,
    required this.advanced,
    required this.notification,
    required this.notTime,
    required this.events,
    required this.sanction,
    required this.showSanction,
    required this.accountant,
    this.type = '',
  });

  SplayTreeMap<DateTime, List> events;
  int streak = 0;
  int? id;
  int position;
  String title;
  bool twoDayRule;
  String cue;
  String routine;
  String reward;
  bool showReward;
  bool advanced;
  bool notification;
  TimeOfDay notTime;
  String sanction;
  bool showSanction;
  String accountant;
  String type;

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? 0,
      'position': position,
      'title': title,
      'twoDayRule': twoDayRule,
      'cue': cue,
      'routine': routine,
      'reward': reward,
      'showReward': showReward,
      'advanced': advanced,
      'notification': notification,
      'notTime': {'hour': notTime.hour,
                  'minutes' : notTime.minute},
      'events': events.map((key, value) {
        return MapEntry(key.toString(), [value[0].toString(), value[1]]);
      }),
      'sanction': sanction,
      'showSanction': showSanction,
      'accountant': accountant,
      'type': type,
    };
  }

   factory HabitData.fromMap(Map<String,dynamic> hab){
   return HabitData(
  id: hab['id'] ?? 0,
  position: hab['position'],
  title: hab['title'],
  twoDayRule: hab['twoDayRule'] == 0 ? false : true,
  cue: hab['cue'] ?? '',
  routine: hab['routine'] ?? '',
  reward: hab['reward'] ?? '',
  showReward: hab['showReward'] == 0 ? false : true,
  advanced: hab['advanced'] == 0 ? false : true,
  notification: hab['notification'] == 0 ? false : true,
  notTime: TimeOfDay(hour: hab['notTime']['hour'], minute: hab['notTime']['minutes']),
  events: SplayTreeMap<DateTime, List>.from(hab['events'].map((key, value) {
    return MapEntry(DateTime.parse(key), [DayType.values[value[0] as int], value[1]]);
  })),
  sanction: hab['sanction'] ?? '',
  showSanction: (hab['showSanction'] ?? 0) == 0 ? false : true,
  accountant: hab['accountant'] ?? '',
  type: hab['type'] ?? '',
  );
  }
}
