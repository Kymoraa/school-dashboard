import 'package:flutter/material.dart';
import 'package:school_dashboard/screens/student_profile.dart';
import 'package:school_dashboard/themes/text_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as console;

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fireStore.collection('students').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No students to display'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final student = snapshot.data!.docs[index].data();
              var studentFullName = student['name'];
              List studentSplitName = studentFullName.split(' ');
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => StudentProfile(
                          studentID: student['id'],
                          studentName: student['name'],
                          studentGrade: student['grade'],
                          studentReg: student['regNumber'],
                        ),
                      ),
                    );
                    setState(() {

                    });
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
                        student['name'],
                        style: context.bodyText1.copyWith(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Registration Number: ${student['regNumber']}',
                        style: context.bodyText2.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
