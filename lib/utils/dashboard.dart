import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

int studentsCount = 0;

Future<int> _getTotalStudents() async {
  final studentsSnapshot = await FirebaseFirestore.instance.collection('students').get();
  studentsCount = studentsSnapshot.size;
  return studentsCount;
}

class Dashboard {
  static List dashboardList = [
    {
      "icon": Icons.people_alt_outlined,
      "title": "Students",
      "item_count": studentsCount,//studentsCount,
      "description": "Total students",
      "color": Colors.blue[200]
    },
    {
      "icon": Icons.tune,
      "title": "Configure",
      "item_count": 03,
      "description": "Configuration(s)",
      "color": Colors.red[200]
    },
    {
      "icon": Icons.library_books_outlined,
      "title": "Reports",
      "item_count": 05,
      "description": "Available report(s)",
      "color": Colors.purple[200]
    },
    {
      "icon": Icons.people_alt_outlined,
      "title": "Teachers",
      "item_count": 24,
      "description": "Active teachers",
      "color": Colors.orange[200]
    },
    {
      "icon": Icons.calendar_today_outlined,
      "title": "Calendar",
      "item_count": 17,
      "description": "Schedule(s)",
      "color": Colors.pink[200]
    },
    {
      "icon": Icons.mail_outline_rounded,
      "title": "Mail",
      "item_count": 07,
      "description": "Message(s)",
      "color": Colors.green[200]
    }
  ];

}