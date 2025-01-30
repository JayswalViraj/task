import 'package:flutter/material.dart';
import 'package:task/global/utils/extentions.dart';

class GloablFuctions {
  Future<String?> pickDate(context, DateTime? initialDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      return pickedDate.toIso8601String();
    }
    return null;
  }

  // Show Time Picker (12-hour format)
  Future<String?> pickTime(context,TimeOfDay? initialTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime??TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String timeString = pickedTime.to24HourFormat();
      return timeString;
    }
    return null;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'new':
        return Colors.blue;
      default:
        return Colors.grey;
    }}
}
