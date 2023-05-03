import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:school_dashboard/screens/student_profile.dart';
import 'package:school_dashboard/themes/text_theme.dart';
import 'dart:developer' as console;

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late DatabaseReference databaseReference;
  var generatedColor = Random().nextInt(Colors.primaries.length);
  List<dynamic> allStudents = [];

  Future<List> getAllStudents() async {
    final databaseInstance = FirebaseDatabase.instance;
    final fruitDetails = await databaseInstance.ref("all-students").once();
    setState(() {
      allStudents = fruitDetails.snapshot.value as List;
    });
    return allStudents;
  }

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
        automaticallyImplyLeading: true,
        elevation: 0.7,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              size: 24.0,
              color: Colors.grey[600],
            ),
            onPressed: () async {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: allStudents.length,
        itemBuilder: (BuildContext context, int index) {
          var studentFullName = allStudents[index]['name'];
          List studentSplitName = studentFullName.split(' ');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){ //console.log(index.toString());
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => StudentProfile(
                      studentID: allStudents[index]['id'],
                      studentName: allStudents[index]['name'],
                      studentBalance: allStudents[index]['balance'],
                      studentGrade: allStudents[index]['grade'],
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[200],
                    child: Text(
                      '${studentSplitName[0][0]}${studentSplitName[1][0]}',
                      style: context.bodyText2.copyWith(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    allStudents[index]['name'],
                    style: context.bodyText1.copyWith(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Student ID: ${allStudents[index]['id']}',
                    style: context.bodyText2.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
