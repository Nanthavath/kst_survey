import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kst_survey/models/doctor.dart';
import 'package:kst_survey/screens/logins/login_screen.dart';
import 'package:kst_survey/screens/pdf/pdf_page.dart';
import 'package:kst_survey/screens/update_screen.dart';
import 'package:kst_survey/services/auth_service.dart';
import 'package:kst_survey/widgets/alert_progress.dart';
import 'create_screen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SummaryScreen extends StatefulWidget {
  static String route = 'summary';

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<String> docID = [];
  List<Doctor> listDoctors = [];
  AuthServices authServices = AuthServices();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    listDoctors.clear();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      key: _drawerKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Image(
                image: AssetImage('assets/images/kst.png'),
                width: 200,
              ),
            ),
            ListTile(
              leading: Image(
                image: AssetImage('assets/images/user.png'),
                width: 40,
              ),
              title: Text('Account'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Image(
                image: AssetImage('assets/images/export.png'),
                width: 40,
              ),
              title: Text('Log out'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Scrollbar(
                child: _body(),
              ),
              _navBar(),
            ],
          ),
        ),
      ),
    );
  }

  _navBar() {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: Center(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MediaQuery.of(context).size.width <= 500
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              MediaQuery.of(context).size.width <= 500
                  ? Container()
                  : Image(
                      image: AssetImage('assets/images/kst.png'),
                      width: 60,
                    ),
              MediaQuery.of(context).size.width <= 500
                  ? IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => _drawerKey.currentState.openDrawer())
                  : Container(),
              _searchTextBox(controller: searchController),
              MediaQuery.of(context).size.width <= 500
                  ? _addData()
                  : Container(),
              MediaQuery.of(context).size.width <= 500
                  ? Container()
                  : _account(),
            ],
          ),
        ),
      ),
    );
  }

  _addData() {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 20),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(CreateScreen.route);
      },
    );
  }

  _account() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: PopupMenuButton(
        tooltip: 'Account',
        iconSize: 45,
        offset: Offset(-10, 60),
        icon: Icon(Icons.account_circle_rounded),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: '1',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/user.png'),
                    width: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Account'),
                ],
              ),
            ),
            PopupMenuItem(
              value: '2',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/export.png'),
                    width: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Log out'),
                ],
              ),
            ),
          ];
        },
        onSelected: (String value) {
          if (value == '1') {}
          if (value == '2') {
            _signOut();
          }
        },
      ),
    );
  }

  _searchTextBox({TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
      width: MediaQuery.of(context).size.width < 700
          ? 265
          : MediaQuery.of(context).size.width / 1.8,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'ຄົນຫາ',
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0.25),
          ),
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(
            Icons.search,
            size: 25,
          ),
          suffixIcon: searchController.text.isEmpty
              ? Container(
                  width: 1,
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        searchController.clear();
                        getData();
                      });
                    },
                  ),
                ),
        ),
        onChanged: (value) {
          value = value.toLowerCase();
          if (value.isEmpty || value == null) {
            setState(() {
              getData();
            });
          } else {
            setState(() {
              listDoctors = listDoctors.where((element) {
                String name = element.firstName.toLowerCase();
                String surname = element.lastName.toLowerCase();
                return name.contains(value) || surname.contains(value);
              }).toList();
            });
          }
        },
      ),
    );
  }

  _body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.all(20),
                width: 1000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Doctor'),
                    MediaQuery.of(context).size.width <= 500
                        ? Container()
                        : _addData(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(listDoctors.length, (index) {
                    return Card(
                      child: Container(
                        width: 1000,
                        padding: EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: listDoctors[index].img == null
                                          ? AssetImage(
                                              'assets/images/doctor.png')
                                          : NetworkImage(
                                              listDoctors[index].img),
                                      width: 200,
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    MediaQuery.of(context).size.width >= 765
                                        ? _dataDetail(index: index)
                                        : Container(),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MediaQuery.of(context).size.width <= 765
                                    ? _dataDetail(index: index)
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _dataDetail({int index}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${listDoctors[index].firstName} ${listDoctors[index].lastName} ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          _textShow(
              title: 'ຕຳແໜ່ງ', data: '${listDoctors[index].currentPosition}'),
          _textShow(
              title: 'ບ່ອນສັງກັດ (ບ່ອນເຮັດວຽກ)',
              data: '${listDoctors[index].office}'),
          _textShow(
              title: 'ເປັນໝໍຊ່ຽວຊານທາງດ້ານ',
              data:
                  '${listDoctors[index].technical.toString().replaceAll('[', '').replaceAll(']', '')}'),
          _textShow(title: 'ເບີໂທ', data: '${listDoctors[index].phone}'),
          _textShow(title: 'Email', data: '${listDoctors[index].email}'),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 15,
            child: Center(
              child: Row(
                children: [
                  InkWell(
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateScreen(
                          docID: docID[index],
                          data: listDoctors[index],
                        ),
                      ));
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  VerticalDivider(
                    thickness: 2,
                    color: Colors.grey,
                    width: 2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      child:
                          Text('Export', style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        _createPDF(data: listDoctors[index]);
                      }),
                ],
              ),
            ),
          ),

          // Container(
          //   margin: EdgeInsets.only(left: 20),
          //   width: 80,
          //   height: 80,
          //   decoration: BoxDecoration(
          //     border: Border.all(width: 3,color: Colors.blue),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Center(
          //     child: Text("100%"),
          //   ),
          // ),
        ],
      ),
    );
  }

  getData() async {
    final CollectionReference doctor =
        FirebaseFirestore.instance.collection('Doctors');
    await doctor.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          listDoctors.add(Doctor.fromMap(doc.data()));
          docID.add(doc.id);
        });
      });
    });
  }

  _textShow({String title, String data}) {
    return Row(
      crossAxisAlignment: MediaQuery.of(context).size.width <= 500
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          '$title:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width < 770 ? 200 : null,
          child: Text(
            data,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }

  void _signOut() async {
    AlertProgress(context: context).optionDialog(onPressed: () async {
      Navigator.pop(context);
      AlertProgress(context: context).loadingAlertDialog();
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      authServices.logOut().then((value) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginScreen.route, (route) => false);
      });
    });
  }

  void _createPDF({Doctor data}) async {
    // final pdf = pw.Document();
    //
    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.Text("Hello World"),
    //       ); // Center
    //     })); // Page
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PDFPage(data: data,),
    ));
  }
}
