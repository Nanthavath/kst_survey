import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class Headings extends pw.StatelessWidget {
  final String number;
  final String title;

  Headings({this.number, this.title});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.only(left: 10,bottom: 10),
      child: pw.Row(children: [
        pw.Container(
          margin: pw.EdgeInsets.only(right: 15),
          width: 20,
          height: 20,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            shape: pw.BoxShape.circle,
          ),
          child: pw.Center(
            child: pw.Text(
              '$number',
              style: pw.TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        pw.Text('$title'),
      ]),
    );
  }
}
