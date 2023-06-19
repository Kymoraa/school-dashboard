import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as console;

import 'package:intl/intl.dart';

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
  final List<String> paymentMethod = ['Bank', 'Cash', 'M-Pesa'];
  late int currentBalance = 0;
  late List payments = [];
  late String selectedValue = '';
  final String timeStamp = '';

  @override
  void initState() {
    super.initState();
    _getBalance(widget.studentID);
    _getPayments(widget.studentID);
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

  Future<List<dynamic>> _getPayments(String documentId) async {
    CollectionReference collReference = FirebaseFirestore.instance.collection('payments');
    QuerySnapshot querySnapshot = await collReference.where('studentID', isEqualTo: widget.studentID).get();
    for (QueryDocumentSnapshot querySnapshot in querySnapshot.docs) {
      payments.add(querySnapshot.data());
    }
    return payments;
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
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
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Registration: ${widget.studentReg}',
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Grade: ${widget.studentGrade}',
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headline5,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20.0),
                  // Add UI for balance
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Balance Ksh: $currentBalance',
                style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment History',
                    style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.headline5,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(CupertinoIcons.line_horizontal_3_decrease)
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: payments.isEmpty
                    ? const Center(
                        child: Text(
                          'No payments to display',
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final timeStamp = DateTime.fromMillisecondsSinceEpoch(payments[index]['timestamp'] ~/ 1000);
                          var paymentDateTime = DateFormat('dd-MM-yyyy, hh:mm a').format(timeStamp);
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Method: ${payments[index]['paymentMethod'].toString()}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Particulars: ${payments[index]['paymentDescription'].toString()}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Date/Time: ${paymentDateTime.toString()}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Amount Ksh: ${payments[index]['paymentAmount'].toString()}',
                                  style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.headline5,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 5.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            )
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
                        Row(
                          children: <Widget>[
                            Icon(CupertinoIcons.creditcard, color: Colors.grey[600]),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  'Payment method',
                                  style: TextStyle(fontSize: 14),
                                ),
                                buttonStyleData: ButtonStyleData(
                                  height: 58,
                                  padding: const EdgeInsets.only(left: 5, right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                items: paymentMethod
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? value) => setState(
                                  () {
                                    if (value != null) selectedValue = value;
                                  },
                                ),
                              ),
                            ),
                          ],
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
                            icon: Icon(CupertinoIcons.number, color: Colors.grey[600]),
                            //icon: SvgPicture.asset('assets/icons/shilling.svg', width: 29, height: 29),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
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
                            hintText: 'Particulars',
                            hintStyle: const TextStyle(fontSize: 14),
                            icon: Icon(
                              CupertinoIcons.text_alignleft,
                              color: Colors.grey[600],
                            ),
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
                      final timestamp = DateTime.now().microsecondsSinceEpoch;
                      final paymentMethod = selectedValue;

                      setState(() {
                        _makePayment(
                          paymentDescription: paymentDescription,
                          paymentAmount: paymentAmount,
                          studentID: studentID,
                          timestamp: timestamp,
                          paymentMethod: paymentMethod,
                        );
                        _updateBalance(balance: balance);
                        _getBalance(widget.studentID);
                        _getPayments(widget.studentID);
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

  Future _makePayment({
    required String paymentDescription,
    required int paymentAmount,
    required String studentID,
    required int timestamp,
    required String paymentMethod,
  }) async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('payments').add(
      {
        'paymentDescription': paymentDescription,
        'paymentAmount': paymentAmount,
        'studentID': studentID,
        'timestamp': timestamp,
        'paymentMethod': paymentMethod,
      },
    );
    String paymentID = docRef.id;
    await FirebaseFirestore.instance.collection('payments').doc(paymentID).update({'id': paymentID});
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
