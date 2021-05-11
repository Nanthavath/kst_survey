import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class Data extends pw.StatelessWidget {
  final String title;
  final String text;

  Data({this.title, this.text});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.only(left: 20, bottom: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('$title:', style: pw.TextStyle(fontSize: 14)),
          pw.SizedBox(width: 5),
          pw.Text('$text', style: pw.TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
