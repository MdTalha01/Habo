import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';


TimeOfDay parseTimeOfDay(String? value) {
  if (value != null) {
    var times = value.split(':');
    if (times.length == 2) {
      return TimeOfDay(hour: int.parse(times[0]), minute: int.parse(times[1]));
    }
  }

  return const TimeOfDay(hour: 12, minute: 0);
}

DateTime transformDate(DateTime date) {
  return DateTime.utc(
    date.year,
    date.month,
    date.day,
    12,
  );
}

 showToast(context ,message,{bool isError = false}) {

   Flushbar(
     // title:  "Hey Ninja",
     margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
     icon: isError ? Icon(Icons.error, color: Colors.white,) : Icon(
       Icons.check_circle, color: Colors.white,),
     backgroundColor: isError ? Colors.red : Colors.green,
     message: message,
     borderRadius: BorderRadius.circular(10),
     borderColor: isError ? Colors.red : Colors.green,
     duration: const Duration(seconds: 4),
     flushbarPosition: FlushbarPosition.TOP,
   )
     ..show(context);
 }