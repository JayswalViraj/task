import 'package:flutter/material.dart';

class CustomTaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String status;
  final String priority;
  final int id;
  final Function() deleteFunction;
  final Function() viewFunction;


  CustomTaskCard({
    required this.title,
    required this.date,
    required this.time,
    required this.status,
    required this.priority,
    required this.id,
    required this.deleteFunction,
    required this.viewFunction
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBadge("P:"+priority, _getPriorityColor(priority)),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove_red_eye, ),
                    onPressed: () {
                      viewFunction();
                    },
                  ),
                ),


              ],
            ),


            SizedBox(height: 10),

            // Status & Priority Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBadge(status, getStatusColor(status)),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, ),
                    onPressed: () {
                      deleteFunction();
                    },
                  ),
                ),



              ],


            ),

            SizedBox(height: 10),

            // Date & Time Row
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[700])),

                SizedBox(width: 16),

                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),

          ],
        ),
      ),
    );
  }





  // Function to get Priority Color
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Badge Widget
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
         color: color.withOpacity(0.2),
       borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

// Function to get Status Color
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
  }
}