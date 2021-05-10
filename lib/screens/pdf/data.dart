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
      padding: pw.EdgeInsets.only(left: 20,bottom: 5),
      child: pw.Row(
        children: [
          pw.Text(
            '$title:',
          ),
          pw.SizedBox(width: 5),
          pw.Text('$text'),
        ],
      ),
    );
  }
}
