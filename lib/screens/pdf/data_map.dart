import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import 'pdf_page.dart';

class DataMap extends pw.StatelessWidget {
  final List<String> titleList;
  final List<String> labelList;
  final Map data;
  final String title;

  DataMap({this.data, this.title, this.titleList, this.labelList});

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
          pw.Container(
            margin: pw.EdgeInsets.only(left: 10, right: 5,),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: List.generate(
                titleList.length,
                (index) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.only( bottom: 10),
                    child: pw.Row(
                      children: [
                        pw.Text(
                          '${labelList[index]}:',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(width: 5),
                        pw.Text(data[titleList[index]],
                            style: pw.TextStyle(fontSize: 14)),
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
  }
}
