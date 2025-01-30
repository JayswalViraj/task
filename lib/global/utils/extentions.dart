import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension Iso8601StringExtension on String {
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
    // Parse the ISO 8601 string to DateTime
  }

  // Format DateTime (from ISO 8601 string) to dd-MMM-yyyy
  String toDDMMMYYYY() {
    try {
      DateTime date = toDateTime()!;
      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (e) {
      return "";
    }
  }

  // Format DateTime (from ISO 8601 string) to 12-hour time format (hh:mm a)
  String to12HourFormat() {
    try {
      DateTime date = toDateTime()!;
      return DateFormat('hh:mm a').format(date);
    } catch (e) {
      return "";
    }
  }

  /// Convert "14:30:00" (24-hour format) to "02:30 PM" (12-hour format)
  String to12HourFormatDayOfTime() {
    try{
      final RegExp regex = RegExp(r'(\d+):(\d+):(\d+)');
      final match = regex.firstMatch(this);
      if (match == null) throw FormatException("Invalid time format: $this");

      int hour = int.parse(match.group(1)!);
      int minute = int.parse(match.group(2)!);
      String period = hour >= 12 ? "PM" : "AM";

      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    }
    catch(e){
      return "";
    }

  }

  /// Convert a "HH:mm:ss" formatted string to TimeOfDay
  TimeOfDay? toTimeOfDay() {
    try {
      final parts = split(":");
      if (parts.length < 2) {
        throw FormatException("Invalid time format. Expected HH:mm:ss.");
      }
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}

extension TimeOfDayExtensions on TimeOfDay {
  /// Convert TimeOfDay to 24-hour format string (e.g., "14:30:00")
  String to24HourFormat() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
  }
}
extension ContextExt on BuildContext {
  bool get isPhone => MediaQuery.of(this).size.width < 600.0;
  bool get isTablet => MediaQuery.of(this).size.width >= 600.0;
}