import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kst_survey/models/data.dart';
import 'package:kst_survey/models/doctor.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFPage extends StatefulWidget {
  final Doctor data;

  const PDFPage({Key key, this.data}) : super(key: key);

  @override
  _PDFPageState createState() => _PDFPageState(data: data);
}

const PdfColor green = PdfColor.fromInt(0xff9ce5d0);

class _PDFPageState extends State<PDFPage> {
  final Doctor data;

  _PDFPageState({this.data});

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/doctor.png')).buffer.asUint8List(),
    );
    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/kst.png')).buffer.asUint8List(),
    );

    final pdf = pw.Document();
    final pageTheme = await _myPageTheme(format);
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          pw.Partitions(
            children: [
              pw.Partition(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Image(
                      logo,
                      height: 50,
                      width: 50,
                      fit: pw.BoxFit.contain,
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 40,
                        bottom: 40,
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'ແບບຟອມເກັບກໍາສະຖິຕິທ່ານໝໍຊ່ຽວຊານ',
                            style: pw.TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          pw.Image(
                            profileImage,
                            height: 150,
                            width: 150,
                            fit: pw.BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(
                        color: Colors.white,
                      ),
                      Container(
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('PDF'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text('EXCEL'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PdfPreview(
                  build: (format) => _generatePdf(format),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
    final bgShape = await rootBundle.loadString('assets/images/resume.svg');
    format = format.applyMargin(
        left: 2.0 * PdfPageFormat.cm,
        top: 4.0 * PdfPageFormat.cm,
        right: 2.0 * PdfPageFormat.cm,
        bottom: 2.0 * PdfPageFormat.cm);

    return pw.PageTheme(
      margin: pw.EdgeInsets.all(30),
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load('assets/fonts/BoonBaan-Regular.ttf')),
        bold: pw.Font.ttf(
            await rootBundle.load('assets/fonts/BoonBaan-Bold.ttf')),
      ),
      buildBackground: (pw.Context context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Stack(
            children: [
              pw.Positioned(
                child: pw.SvgImage(svg: bgShape),
                left: 0,
                top: 0,
              ),
              pw.Positioned(
                child: pw.Transform.rotate(
                    angle: pi, child: pw.SvgImage(svg: bgShape)),
                right: 0,
                bottom: 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
