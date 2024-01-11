import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static ThemeData lightThemeData = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color.fromARGB(255, 65, 14, 160),
      onPrimary: Colors.black,
      secondary: Color.fromARGB(255, 140, 140, 140),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: const Color.fromARGB(255, 65, 14, 160),
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
        size: 24,
      ),
      backgroundColor: Colors.white,
      elevation: 1,
    ),
    useMaterial3: true,
    primaryColor: const Color.fromARGB(255, 57, 11, 57),
  );

  static ThemeData darkThemeData = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme()),
    colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 57, 11, 57),
      primary: Color.fromARGB(255, 67, 215, 245),
      onBackground: Colors.white,
      onPrimary: Colors.white,
      secondary: Color.fromARGB(255, 182, 182, 182),
    ),
    drawerTheme: const DrawerThemeData(),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
      backgroundColor: Color.fromARGB(255, 57, 11, 57),
      elevation: 5,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 215, 245),
      ),
    ),
    useMaterial3: true,
    primaryColor: const Color.fromARGB(255, 57, 11, 57),
  );
}
