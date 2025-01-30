import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.orange,
  brightness: Brightness.light,
  textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      titleSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.grey[600],
      ),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,
        color: Colors.grey[600],),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: Colors.grey.withOpacity(0.5),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    hintStyle: TextStyle(
      color: Colors.grey[600], // Lighter hint text color
      fontSize: 14, // Adjust the hint font size for a balanced look
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey[600],
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
  ),
);
final darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(fontSize: 16, color: Colors.white),
      titleSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w300,
        color: Colors.grey[600],
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Colors.grey[600],
      )),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: Colors.grey.withOpacity(0.5),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    hintStyle: TextStyle(
      color: Colors.grey[600], // Lighter hint text color
      fontSize: 14, // Adjust the hint font size for a balanced look
    ),
    filled: true,
    labelStyle: TextStyle(
      fontSize: 16,
      color: Colors.grey[600],
    ),
    fillColor: Colors.black.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners for enabled state
      borderSide: BorderSide(
        color: Colors.grey
            .withOpacity(0.5), // Light gray border for the disabled state
        width: 1.5,
      ),
    ),
  ),
);
