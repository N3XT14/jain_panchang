import 'package:flutter/material.dart';
import 'package:jain_panchang/shared/navigation_drawer/domain/entities.dart';

class NavigationDrawerData {
  static List<NavigationDrawerModel> ndd = [
    NavigationDrawerModel(
      Icons.grid_view,
      "Dashboard",
      [],
    ),
    NavigationDrawerModel(
      Icons.calendar_today,
      "Calendar",
      [],
    ),
    NavigationDrawerModel(
      Icons.settings,
      "Settings",
      [],
    )
  ];
}
