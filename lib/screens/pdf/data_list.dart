import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import 'pdf_page.dart';

class DataList extends pw.StatelessWidget {
  final List data;
  final String title;

  DataList({this.data, this.title});
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$title',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Column(
            children: List.generate(
              data.length,
                  (index) {
                return pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 10),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        margin: pw.EdgeInsets.only(left: 10, right: 5),
                        width: 8,
                        height: 8,
                        decoration: pw.BoxDecoration(
                          color: green,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.Text(data[index]),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
