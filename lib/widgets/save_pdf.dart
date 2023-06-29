import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

buildSavePDF(image, studentName, studentReg, studentGrade, currentBalance, payments) => pw.Padding(
      padding: const pw.EdgeInsets.all(18.00),
      child: pw.Column(
        children: [
          pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Image(image, width: 200, height: 200),
          ),
          pw.Text(
            'Mystic Rose Primary School',
            style: const pw.TextStyle(fontSize: 17.00),
          ),
          pw.Divider(),
          pw.SizedBox(height: 15.00),
          pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.Text(
              'Name: $studentName \nRegistration: $studentReg \nGrade: $studentGrade',
              style: const pw.TextStyle(fontSize: 15.00),
            ),
          ),
          pw.SizedBox(
            height: 10.00,
          ),
          pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.Text(
              'Balance Ksh: $currentBalance',
              style: pw.TextStyle(fontSize: 15.00, fontStyle: pw.FontStyle.italic),
            ),
          ),
          pw.SizedBox(height: 15.00),
          pw.Text(
            'Payment History',
            style: const pw.TextStyle(
              fontSize: 17.00,
            ),
          ),
          pw.Divider(),
          pw.Expanded(
            child: payments.isEmpty
                ? pw.Center(
                    child: pw.Text(
                      'No payments to display',
                    ),
                  )
                : pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final timeStamp = DateTime.fromMillisecondsSinceEpoch(payments[index]['timestamp'] ~/ 1000);
                        var paymentDateTime = DateFormat('dd-MM-yyyy, hh:mm a').format(timeStamp);
                        return pw.Container(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Payment Method: ${payments[index]['paymentMethod'].toString()}',
                              ),
                              pw.Text(
                                'Particulars: ${payments[index]['paymentDescription'].toString()}',
                              ),
                              pw.Text(
                                'Date/Time: ${paymentDateTime.toString()}',
                              ),
                              pw.Text(
                                'Amount Ksh: ${payments[index]['paymentAmount'].toString()}',
                              ),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Divider(color: PdfColors.pink100),
                              pw.SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
