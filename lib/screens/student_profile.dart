import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_dashboard/themes/text_theme.dart';
import 'dart:developer' as console;

class StudentProfile extends StatefulWidget {
  const StudentProfile({
    Key? key,
    required this.studentID,
    required this.studentName,
    required this.studentGrade,
    required this.studentReg,
  }) : super(key: key);

  final String studentID;
  final String studentName;
  final String studentGrade;
  final String studentReg;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late int currentBalance = 0;

  @override
  void initState() {
    super.initState();
    _getBalance(widget.studentID);
  }

  Future<void> _getBalance(String documentId) async {
    try {
      DocumentSnapshot snapshot = await fireStore.collection('students').doc(documentId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          currentBalance = data['balance'];
        });
      }
    } catch (e) {
      print('Error getting field value: $e');
    }
  }

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
            Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.blue[200],
                  child: Text(
                    '${studentSplitName[0][0]}${studentSplitName[1][0]}',
                    style: const TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      widget.studentName,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.studentReg,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                // Add UI for balance
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              'Balance: $currentBalance',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _paymentFAB(),
    );
  }

  Widget _paymentFAB() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(seconds: 2),
      tween: Tween<Offset>(
        begin: const Offset(0, -800),
        end: const Offset(0, 0),
      ),
      curve: Curves.bounceOut,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Make Payment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                content: SizedBox(
                  height: height * 0.35,
                  width: width,
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: descriptionController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            hintText: 'Description',
                            hintStyle: const TextStyle(fontSize: 14),
                            icon: Icon(CupertinoIcons.text_alignleft, color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            hintText: 'Amount',
                            hintStyle: const TextStyle(fontSize: 14),
                            icon: Icon(CupertinoIcons.creditcard, color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final paymentDescription = descriptionController.text;
                      final paymentAmount = int.parse(amountController.text);
                      final studentID = widget.studentID;
                      final balance = currentBalance - paymentAmount;

                      setState(() {
                        _makePayment(
                            paymentDescription: paymentDescription, paymentAmount: paymentAmount, studentID: studentID);
                        _updateBalance(balance: balance);
                        _getBalance(widget.studentID);
                      });

                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink[200],
                    ),
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.pink[200],
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: width * 0.08,
        ),
      ),
    );
  }

  Future _makePayment(
      {required String paymentDescription, required int paymentAmount, required String studentID}) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('payments').add(
      {
        'paymentDescription': paymentDescription,
        'paymentAmount': paymentAmount,
        'studentID': studentID,
      },
    );
    String paymentID = docRef.id;
    await FirebaseFirestore.instance.collection('payments').doc(paymentID).update(
      {'id': paymentID},
    );
    _clearAll();
  }

  Future _updateBalance({required int balance}) async {
    var collection = FirebaseFirestore.instance.collection('students');
    collection.doc(widget.studentID).update({'balance': balance});
  }

  void _clearAll() {
    descriptionController.text = '';
    amountController.text = '';
  }
}
