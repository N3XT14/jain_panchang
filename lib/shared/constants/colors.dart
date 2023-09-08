part of './constants.dart';

class AppColors {
  static MaterialColor primary = const MaterialColor(
    _primaryValue, // Define the primary color's 500 shade
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_primaryValue), // Primary color
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  static const int _primaryValue = 0xFF42A5F5;
  static const Color serenityBlue = Color(0xFF90A4AE);
  static const Color skyBlue = Color(0xFF42A5F5);
  static const Color tranquilBlue = Color(0xFF64B5F6);
  static const Color spiritualIndigo = Color(0xFF5C6BC0);
  static const Color calmTeal = Color(0xFF26A69A);

  //drawer color
  static const Color complexDrawerCanvasColor = Color(0xffe3e9f7);
  static const Color complexDrawerBlack = Color(0xff11111d);
  static const Color complexDrawerBlueGrey = Color(0xff1d1b31);
}
