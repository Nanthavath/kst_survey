import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import 'pdf_page.dart';

class DataMap extends pw.StatelessWidget {
  final List<String> titleList;
  final Map data;
  final String title;

  DataMap({this.data, this.title, this.titleList});

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
          pw.Container(
            margin: pw.EdgeInsets.only(left: 10, right: 5),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(
                titleList.length,
                (index) {
                  return pw.Row(
                    children: [
                      pw.Text(
                        '${titleList[index]}:',
                      ),
                      pw.SizedBox(width: 5),
                      pw.Text(data[titleList[index]]),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
