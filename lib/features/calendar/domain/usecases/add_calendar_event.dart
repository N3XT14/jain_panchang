import 'package:flutter/material.dart';

class AddEventUseCase {
  void execute(
      DateTime date, Widget event, Map<DateTime, List<Widget>> events) {
    if (events[date] == null) {
      events[date] = [event];
    } else {
      events[date]!.add(event);
    }
  }
}
