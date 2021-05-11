import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kst_survey/models/data.dart';
import 'package:kst_survey/models/doctor.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'data.dart';
import 'data_list.dart';
import 'data_map.dart';
import 'heading.dart';

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
    final pdf = pw.Document(title: 'Information');

    final pageTheme = await _myPageTheme(format);
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (context) {
          return pw.Image(
            logo,
            height: 50,
            width: 50,
            fit: pw.BoxFit.contain,
          );
        },
        build: (context) => [
          pw.Container(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.SizedBox(height: 20),
                pw.Text(
                  'ແບບຟອມເກັບກໍາສະຖິຕິທ່ານໝໍຊ່ຽວຊານ',
                  style: pw.TextStyle(
                    fontSize: 20,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  // crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Image(
                      profileImage,
                      height: 150,
                      width: 150,
                      fit: pw.BoxFit.contain,
                    ),
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          Data(
                            title: 'ຊື່ ແລະ ນາມສະກຸນ',
                            text: '${data.firstName} ${data.lastName}',
                          ),
                          Data(
                            title: 'ວັນເດືອນປີເກີດ',
                            text: '${data.birthDay}',
                          ),
                          Data(
                            title: 'ຕໍາແໜ່ງປັດຈຸບັນ',
                            text: '${data.currentPosition}',
                          ),
                          Data(
                            title: 'ບ່ອນສັງກັດ (ບ່ອນເຮັດວຽກ)',
                            text: '${data.office}',
                          ),
                          Data(
                            title: 'ບ້ານຢູ່ປັດຈຸບັນ',
                            text: '${data.office}',
                          ),
                          Data(
                            title: 'ເບີໂທ',
                            text: '${data.phone}',
                          ),
                          Data(
                            title: 'Email',
                            text: '${data.email}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Divider(color: PdfColor.fromHex('#e6e6e6')),
                pw.Container(
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            DataList(
                              title: 'ເປັນໝໍຊ່ຽວຊານດ້ານ',
                              data: data.technical,
                            ),
                            pw.Text(
                              'ເປັນອາຈານສອນ',
                              style: pw.TextStyle(fontSize: 16),
                            ),
                            pw.SizedBox(height: 10),
                            Data(title: 'ສະຖານທີ່ສອນ', text: data.teachAt),
                            DataList(
                              title: 'ມີ Connection /Power ກັບ',
                              data: data.connection,
                            ),
                            DataList(
                              title: 'ເສດຖະກິດຄອບຄົວ',
                              data: data.familyBusiness,
                            ),
                          ],
                        ),
                      ),
                      pw.VerticalDivider(),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            DataMap(
                              title: 'ຂໍ້ມູນສ່ວນໂຕ',
                              titleList: ['community', 'sportType', 'hobbies'],
                              labelList: [
                                'ເຂົ້າສັງຄົມ/ ສັງສັນ',
                                'ຫຼິ້ນກິລາ',
                                'ກິຈະກຳເວລາວ່າງ'
                              ],
                              data: data.personal,
                            ),
                            pw.Text(
                                'ສະມາຊິກໃນຄອບຄົວ: ${data.familys['member']} ຄົນ',
                                style: pw.TextStyle(fontSize: 16)),
                            pw.SizedBox(height: 5),
                            DataList(
                              title: 'ຜູ້ເຮັດວຽກນໍາລັດ',
                              data: data.familys['workingAtGov'],
                            ),
                            DataMap(
                              title:
                                  'ໝາຍເຫດ: ສະມາຊິກໃນຄອບຄົວ ເຮັດວຽກທີ່ກ່ຽວຂ້ອງກັບວຽກງານສຸຂະພາບ & ການເງີນ ໃນສາຂາການແພດ',
                              labelList: [
                                'ຊື່',
                                'ນາມສະກຸນ',
                                'ເບີໂທຕິດຕໍ່',
                                'ສະຖານທີ່ເຮັດວຽກ',
                                'ຕໍາແໜ່ງ'
                              ],
                              titleList: [
                                'firstName',
                                'lastName',
                                'phone',
                                'office',
                                'position'
                              ],
                              data: data.remark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Divider(color: PdfColor.fromHex('#e6e6e6')),
                pw.SizedBox(height: 10),
                DataMap(
                  title:
                      'ເປັນທີ່ປຶກສາ ຫຼື KOL ໃຫ້ກັບບໍລິສັດຄູ່ແຂ່ງ ຫຼື ສີນຄ້າອື່ນທີ່ບໍ່ແມ່ນຂອງບໍລິສັດເຮົາ',
                  labelList: ['ບໍລິສັດ', 'ສິນຄ້າ'],
                  titleList: ['company', 'product'],
                  data: data.kol,
                ),
                pw.Container(
                  padding: pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromHex('#e6e6e6')),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text('ຜົນປະໂຫຍດທີ່ໄດ້ຮັບຈາກບໍລິສັດອື່ນ',
                          style: pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('${data.benefits}'),
                    ],
                  ),
                ),
                pw.Container(
                  padding: pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColor.fromHex('#e6e6e6')),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text('ຂໍ້ມູນອື່ນໆ', style: pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.Text('${data.other}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  dynamicLayout: true,
                  maxPageWidth: 700,
                  initialPageFormat: PdfPageFormat.a4,
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
        base:
            pw.Font.ttf(await rootBundle.load('assets/fonts/saysettha_ot.ttf')),
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
