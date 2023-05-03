import 'package:flutter/material.dart';
import 'package:school_dashboard/themes/text_theme.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({
    Key? key,
    required this.studentID,
    required this.studentName,
    required this.studentBalance,
    required this.studentGrade,
  }) : super(key: key);

  final String studentID;
  final String studentName;
  final int studentBalance;
  final String studentGrade;


  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  Widget build(BuildContext context) {
    List studentSplitName = widget.studentName.split(' ');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentName),
        automaticallyImplyLeading: true,
        elevation: 0.7,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 24.0,
              color: Colors.grey[600],
            ),
            onPressed: () async {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.blue[200],
              child: Text(
                '${studentSplitName[0][0]}${studentSplitName[1][0]}',
                style: context.bodyText2.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.studentName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Student ID: ${widget.studentID}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
