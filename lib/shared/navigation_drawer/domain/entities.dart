import 'package:flutter/material.dart';

class NavigationDrawerModel {
  //navigation drawer menu
  final IconData icon;
  final String title;
  final List<String> submenus;

  NavigationDrawerModel(
    this.icon,
    this.title,
    this.submenus,
  );
}
