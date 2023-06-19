import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_dashboard/screens/login.dart';
import 'package:school_dashboard/screens/students.dart';
import 'package:school_dashboard/screens/configure.dart';
import 'dart:developer' as console;

import 'package:school_dashboard/utils/dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int studentsCount = 0;
  List dashboardList = Dashboard.dashboardList;

  @override
  void initState() {
    super.initState();
    _getTotalStudents();
  }

  Future<int> _getTotalStudents() async {
    final studentsSnapshot = await FirebaseFirestore.instance.collection('students').get();
    studentsCount = studentsSnapshot.size;
    return studentsCount;
  }

  double getRandom(int min, int max) {
    Random random;
    random = Random();
    return double.parse("${min + random.nextInt(max - min)}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('You are about to log out'),
            content: const Text('Proceed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
          elevation: 0.7,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: IconButton(
              icon: Icon(
                Icons.dashboard_rounded,
                size: 24.0,
                color: Colors.grey[600],
              ),
              onPressed: () async {},
            ),
          ),
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraint) {
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        dashboardList.length,
                        (index) {
                          var item = dashboardList[index];
                          var size = (constraint.biggest.width - 16) / 2;
                          return InkWell(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const StudentsScreen()));
                                  break;
                                case 1:
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => const ConfigurationScreen()));
                                  break;
                                default:
                                // Do nothing.
                              }
                            },
                            child: Container(
                              height: size * 1.2,
                              width: size,
                              decoration: BoxDecoration(
                                color: item["color"],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              item["icon"],
                                              size: 32,
                                              color: Colors.white,
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                              size: 22,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item["title"],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${item["item_count"]}",
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          item["description"],
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      radius: getRandom(40, 50),
                                    ),
                                  ),
                                  Positioned(
                                    right: getRandom(20, 40),
                                    bottom: getRandom(70, 100),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      radius: 17.0,
                                    ),
                                  ),
                                  Positioned(
                                    right: getRandom(79, 100),
                                    bottom: getRandom(20, 60),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      radius: 7.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
