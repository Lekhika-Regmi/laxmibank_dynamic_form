import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF008DB8), // Blue
    surface: Colors.white,
    brightness: Brightness.light,
    primary: Color(0xFF008DB8),
    secondary: Color(0xFFFFCB05), // Yellow
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF008DB8),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFCB05),
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 10),
      minimumSize: Size(double.infinity, 56),
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xffEF7D17),
    brightness: Brightness.dark,
    primary: Color(0xffEF7D17),
    secondary: Color(0xFFFFCB05),
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Color(0xffEF7D17),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFCB05),
      foregroundColor: Colors.black,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);
