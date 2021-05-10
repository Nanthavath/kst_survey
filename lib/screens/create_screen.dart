import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kst_survey/models/doctor.dart';
import 'package:kst_survey/services/firestore_service.dart';
import 'package:kst_survey/widgets/alert_progress.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:typed_data';
import "package:universal_html/html.dart" as html;

class CreateScreen extends StatefulWidget {
  static String route = '/data';

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

enum Gender { Male, Female }
enum Teacher { Yes, No }
enum FamilyWorking { Yes, No }

class _CreateScreenState extends State<CreateScreen> {
  ///Get Image
  String name = '';
  String error;
  Uint8List data;
  String url = '';

  Future getImage() async {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
          Reference refer =
              FirebaseStorage.instance.ref().child('image/${Uuid().v1()}');
          final UploadTask uploadTask = refer.putData(data);
          uploadTask.whenComplete(() async {
            print('Upload Success');
            String data = await uploadTask.snapshot.ref.getDownloadURL();
            setState(() {
              url = data;
            });
          });
        });
      });
    });
    input.click();
  }

  Gender _gender = Gender.Male;
  Teacher _teacher = Teacher.No;
  String birthDat = '';

  ///Technical
  bool isChecked = false;
  List<String> technical = [
    "ຜ່າຕັດຜ່ານທໍ່",
    "ເຄື່ອງຊ່ວຍຫາຍໃຈ",
    "ເຄື່ອງຟອກໄຂ່ຫຼັງ",
    "ເຄື່ອງຊ່ອງກະເພາະ",
    "CT Scan",
    "MRI",
    "Memmogram",
    "ເຄື່ອງວິເຄາະ",
    "ເຄື່ອງວາງຢາສະຫຼົບ",
    "ອື່ນໆ"
  ];
  List<String> selectTech = [];
  List<String> connectedWith = [];
  List<String> familyBusiness = [];

  ///Family
  FamilyWorking _familyWorking = FamilyWorking.No;
  List<String> workWithGov = [];

  ///TextEditing Controller
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController currentPositionController = TextEditingController();
  TextEditingController officeController = TextEditingController();
  TextEditingController currentVillageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController otherTechnicalController = TextEditingController();

  TextEditingController teachController = TextEditingController();
  TextEditingController memberController = TextEditingController();

  ///Community
  TextEditingController communityController = TextEditingController();
  TextEditingController sportTypeController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();

  TextEditingController ownBusinessController = TextEditingController();

  ///Remark
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController workingController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  ///OtherInformation
  TextEditingController companyController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController benefitsController = TextEditingController();
  TextEditingController otherController = TextEditingController();

  ///Service;

  //FireStoreServiceRepo _fireStoreServiceRepo;
  ///Connect With
  TextEditingController unitsController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.note),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'ແບບຟອມເກັບກໍາສະຖິຕິທ່ານໝໍຊ່ຽວຊານ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                              onPressed: () {
                                _insertDataToFireStore();
                              },
                              child: Text("Save")),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Card(
                    child: SingleChildScrollView(
                      child: Container(
                        width: 800,
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 30),
                        child: _body(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _body() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Logo Widget
            Padding(
              padding: EdgeInsets.all(20),
              child: Image(
                image: AssetImage('assets/images/kst.png'),
                width: 60,
                height: 60,
              ),
            ),

            ///Image Widget
            Padding(
              padding: const EdgeInsets.only(left: 60, bottom: 30),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: error != null
                          ? Text(error)
                          : data != null
                              ? Image.memory(data)
                              : Center(
                                  child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ))),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      icon: Icon(Icons.upload_rounded),
                      label: Text(
                        'Upload',
                      ),
                      onPressed: () {
                        getImage();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            ///Personal Data Widget
            _heading(number: 'I', title: 'ຂໍ້ມູນສ່ວນໂຕ (Personal Information)'),
            _personalData(),
            SizedBox(
              height: 50,
            ),
            //
            ///Technical information Widget
            _heading(
                number: 'II',
                title: 'ຂໍ້ມູນດ້ານວິຊາການ (Technical Information)'),
            SizedBox(
              height: 15,
            ),
            _heading1(number: '1', title: 'ເປັນໝໍຊ່ຽວຊານດ້ານໃດ?'),
            _expertTechnicalCheckBox(),
            SizedBox(
              height: 20,
            ),

            ///Teacher
            _heading1(number: '2', title: 'ເປັນອາຈານສອນບໍ່?'),
            _teacherRadio(),

            SizedBox(
              height: 20,
            ),

            ///Connection with
            _heading1(number: '3', title: 'ມີ Connection / Power ກັບ'),
            _connectionWith(),

            SizedBox(
              height: 30,
            ),

            ///(Family & Business Information)
            _heading(
                number: 'III',
                title:
                    'ຂໍ້ມູນຄອບຄົວ ແລະ ທຸລະກິດ (Family & Business Information)'),
            SizedBox(
              height: 20,
            ),
            _heading1(number: '1', title: 'ເສດຖະກິດຄອບຄົວ'),
            _familyBusiness(),
            SizedBox(
              height: 30,
            ),

            ///Personal Doctor data
            _heading1(number: '2', title: 'ຂໍ້ມູນສ່ວນໂຕຂອງທ່ານໝໍ:'),
            _personalDoctorData(),

            SizedBox(
              height: 30,
            ),

            _heading1(number: '3', title: 'ສະມາຊິກໃນຄອບຄົວ:'),
            _familyMember(),
            SizedBox(
              height: 30,
            ),

            ///Remark
            ///
            _remarkWidget(),

            SizedBox(
              height: 30,
            ),

            ///Other Information
            _heading(
                number: 'IV',
                title:
                    "ຄໍາເຫັນຂອງທິມງານພາຍໃນບໍລິສັດ(ຜູ້ທີ່ຮູ້ຈັກ/ລື້ງເຄີຍກັບທ່ານໝໍ) Other Information"),
            SizedBox(
              height: 20,
            ),

            ///KOL
            _heading1(
                number: '1',
                title:
                    'ເປັນທີ່ປຶກສາ ຫຼື KOL ໃຫ້ກັບບໍລິສັດຄູ່ແຂ່ງ ຫຼື ສີນຄ້າອື່ນທີ່ບໍ່ແມ່ນຂອງບໍລິສັດເຮົາບໍ່?'),
            _textInput(label: 'ບໍລິສັດໃດ', controller: companyController),
            _textInput(label: 'ສິນຄ້າໃດ', controller: productController),
            SizedBox(
              height: 30,
            ),

            ///Benefits
            _heading1(
                number: '2', title: 'ຜົນປະໂຫຍດທີ່ໄດ້ຮັບຈາກບໍລິສັດອື່ນ (ຖ້າມີ)'),
            _textOther(controller: benefitsController),

            ///Other
            _heading1(number: '3', title: 'ຂໍ້ມູນອື່ນໆ:'),
            _textOther(controller: otherController),
          ],
        ),
      ),
    );
  }

  _personalDoctorData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _personal(
            label: 'ມັກການສັງສັນບໍ່ (ກີນດື່ມ/ເຂົ້າສັງຄົມ)',
            controller: communityController),
        _personal(
            label: 'ມັກກິລາບໍ່, ຖ້າມັກ ແມ່ນກິລາປະເພດໃດ',
            controller: sportTypeController),
        _personal(
            label: 'ນອກເໜືອຈາກນີ້ ເພີ່ນມັກເຮັດຫຍັງໃນເວລາຫວ່າງ',
            controller: hobbiesController),
      ],
    );
  }

  ///PersonalData Widget
  _personalData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textInput(
            label: 'ຊື່', hint: 'Required', controller: firstNameController),
        _textInput(
            label: 'ນາມສະກຸນ',
            hint: 'Required',
            controller: lastNameController),
        _genderWidget(),
        _birthDay(),
        _textInput(
            label: 'ຕຳແໜ່ງປັດຈຸບັນ',
            hint: 'Optional',
            controller: currentPositionController),
        _textInput(
            label: "ບ່ອນສັງກັດ (ບ່ອນເຮັດວຽກ)",
            hint: 'Optional',
            controller: officeController),
        _textInput(
            label: 'ບ້ານຢູ່ປັດຈຸບັນ',
            hint: 'Optional',
            controller: currentVillageController),
        _textInput(
            label: 'ເບີໂທ', hint: 'Optional', controller: phoneController),
        _textInput(
            label: 'Email (ຖ້າມີ)',
            hint: 'Optional',
            controller: emailController),
      ],
    );
  }

  ///Heading
  _heading({String number, String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
              child: Text(
            '$number',
            style: TextStyle(fontSize: 18),
          )),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width <= 500 ? 262 : null,
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  ///Text Input
  _textInput({String label, String hint, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  contentPadding: EdgeInsets.all(10)),
            ),
          ),
        ],
      ),
    );
  }

  ///Other Information
  _textOther({TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 20, bottom: 20),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 500,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              hintText: 'Text',
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }

  ///Remark Widgets
  _remarkWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Text(
            'ໝາຍເຫດ: ຖ້າສະມາຊິກໃນຄອບຄົວ ເຮັດວຽກທີ່ກ່ຽວຂ້ອງກັບວຽກງານສຸຂະພາບ & ການເງີນ ໃນສາຂາການແພດ, ແມ່ນໃຫ້ຕື່ມຂໍ້ມູນ ຕໍ່ດ້ານລຸ່ມ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        _textInput(label: 'ຊື່', controller: nameController),
        _textInput(label: 'ນາສະກຸນ', controller: surnameController),
        _textInput(label: 'ເບີໂທ', controller: telController),
        _textInput(label: 'ບ່ອນເຮັດວຽກ', controller: workingController),
        _textInput(label: 'ຕຳແໜ່ງ', controller: positionController),
      ],
    );
  }

  ///Member of Family
  _familyMember() {
    return Padding(
      padding: EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('ສະມາຊິກໃນຄອບຄົວມີຈັກຄົນ:'),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  controller: memberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(10)),
                ),
              ),
            ],
          ),
          Text('ມີຜູ້ເຮັດວຽກນໍາລັດບໍ່?'),
          ListTile(
            title: Text('ບໍ່ມີ'),
            leading: Radio(
              value: FamilyWorking.No,
              groupValue: _familyWorking,
              onChanged: (value) {
                setState(() {
                  _familyWorking = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('ມີ'),
            leading: Radio(
              value: FamilyWorking.Yes,
              groupValue: _familyWorking,
              onChanged: (value) {
                setState(() {
                  _familyWorking = value;
                });
              },
            ),
          ),
          _familyWorking == FamilyWorking.Yes
              ? Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text('ຖ້າມີ ແມ່ນໃຜ'),
                      Expanded(
                        child: CheckboxGroup(
                          orientation: GroupedButtonsOrientation.HORIZONTAL,
                          padding: EdgeInsets.all(20),
                          labels: [
                            'ຜົວ/ເມຍ',
                            'ລູກ',
                          ],
                          onSelected: (List<String> value) {
                            setState(() {
                              workWithGov = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  ///

  _personal({String label, TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.only(left: 50, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: 400,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'ລະບຸ',
              ),
            ),
          ),
        ],
      ),
    );
  }

  _familyBusiness() {
    return Padding(
      padding: EdgeInsets.only(left: 50),
      child: Column(
        children: [
          CheckboxGroup(
            labels: [
              'ພະນັກງານລັດຢ່າງດຽວ',
              'ບໍານານ',
              'ກຽມບໍານານ',
              'ມີທຸລະກິດສ່ວນໂຕ',
            ],
            onSelected: (List<String> value) {
              setState(() {
                familyBusiness = value;
              });
            },
          ),
          familyBusiness.contains('ມີທຸລະກິດສ່ວນໂຕ')
              ? TextField(
                  controller: ownBusinessController,
                  decoration: InputDecoration(
                    hintText: 'ລະບຸ',
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  ///Connection/Power
  _connectionWith() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      width: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CheckboxGroup(
              labels: ['ກະຊວງ', 'ລັດຖະມົນຕີ', 'ກົມ', 'ໂຮງຫມໍ'],
              onSelected: (List<String> value) {
                setState(() {
                  connectedWith = value;
                });
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                connectedWith.contains('ກົມ')
                    ? TextField(
                        controller: unitsController,
                        decoration: InputDecoration(
                            labelText: 'ລະບຸຊື່ກົມ', isDense: true),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                connectedWith.contains('ໂຮງຫມໍ')
                    ? TextField(
                        controller: hospitalController,
                        decoration: InputDecoration(
                            labelText: 'ລະບຸຊື່ໂຮງຫມໍ', isDense: true),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _teachLocate() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        width: 500,
        child: TextField(
          controller: teachController,
          decoration: InputDecoration(
            hintText: 'ແຂວງ-ລະບຸຊື່ແຂວງ',
          ),
        ),
      ),
    );
  }

  _teacherRadio() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('ບໍ່ເປັນ'),
            leading: Radio<Teacher>(
              value: Teacher.No,
              groupValue: _teacher,
              onChanged: (Teacher value) {
                setState(() {
                  _teacher = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('ເປັນ'),
            leading: Radio<Teacher>(
              value: Teacher.Yes,
              groupValue: _teacher,
              onChanged: (Teacher value) {
                setState(() {
                  _teacher = value;
                });
              },
            ),
          ),
          _teacher == Teacher.Yes ? _teachLocate() : Container(),
        ],
      ),
    );
  }

  _expertTechnicalCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxGroup(
            labels: technical,
            onSelected: (List<String> checked) {
              setState(() {
                selectTech = checked;
              });
            },
          ),
          SizedBox(
            width: 500,
            child: TextField(
              controller: otherTechnicalController,
              decoration: InputDecoration(
                  labelText: 'ອື່ນໆ',
                  enabled: selectTech.contains('ອື່ນໆ') ? true : false),
            ),
          ),
        ],
      ),
    );
  }

  _heading1({String number, String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: Text('$number')),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width <= 500 ? 265 : null,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _birthDay() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          ElevatedButton.icon(
              onPressed: () async {
                final choice = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                  builder: (BuildContext context, Widget child) {
                    return Center(
                      child: child,
                    );
                  },
                );
                setState(() {
                  birthDat = '${choice.day}/${choice.month}/${choice.year}';
                });
              },
              icon: Icon(Icons.date_range),
              label: Text('ເລືອກ')),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 190,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text('$birthDat'),
            ),
          ),
        ],
      ),
    );
  }

  _genderWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          ListTile(
            title: Text('ຊາຍ'),
            leading: Radio(
              value: Gender.Male,
              groupValue: _gender,
              onChanged: (Gender value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('ຍິງ'),
            leading: Radio(
              value: Gender.Female,
              groupValue: _gender,
              onChanged: (Gender value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _insertDataToFireStore() {
    ///Gender
    String gender = '';
    if (_gender == Gender.Male) {
      gender = "ຊາຍ";
    } else {
      gender = "ຍິງ";
    }

    ///Technical

    if (selectTech.contains('ອື່ນໆ')) {
      selectTech.remove('ອື່ນໆ');
      selectTech.add('ອື່ນໆ:${otherTechnicalController.text}');
    } else {
      selectTech.remove('ອື່ນໆ:${otherTechnicalController.text}');
    }

    ///Connection with/Power
    if (connectedWith.contains('ກົມ')) {
      connectedWith.remove('ກົມ');
      connectedWith.add('ກົມ:${unitsController.text}');
    } else {
      connectedWith.remove('ກົມ:${unitsController.text}');
    }

    if (connectedWith.contains('ໂຮງຫມໍ')) {
      connectedWith.remove('ໂຮງຫມໍ');
      connectedWith.add('ໂຮງຫມໍ:${hospitalController.text}');
    } else {
      connectedWith.remove('ໂຮງຫມໍ:${hospitalController.text}');
    }

    ///Family Business
    if (familyBusiness.contains('ມີທຸລະກິດສ່ວນໂຕ')) {
      familyBusiness.remove('ມີທຸລະກິດສ່ວນໂຕ');
      familyBusiness.add('ມີທຸລະກິດສ່ວນໂຕ:${ownBusinessController.text}');
    } else {
      familyBusiness.remove('ມີທຸລະກິດສ່ວນໂຕ:${ownBusinessController.text}');
    }

    if (firstNameController.text.trim().length == 0 ||
        lastNameController.text.trim().length == 0) {
      AlertProgress(
        context: context,
        message: "Please fill FirstName and LastName",
      ).errorDialog();
    } else {
      AlertProgress(context: context).loadingAlertDialog();
        Doctor doctors = Doctor(
          img: url,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          gender: gender,
          email: emailController.text,
          phone: phoneController.text,
          currentVillage: currentVillageController.text,
          office: officeController.text,
          currentPosition: currentPositionController.text,
          birthDay: birthDat,
          technical: selectTech,
          teachAt: teachController.text,
          connection: connectedWith,
          familyBusiness: familyBusiness,
          personal: {
            'community': communityController.text,
            'sportType': sportTypeController.text,
            'hobbies': hobbiesController.text,
          },
          familys: {
            'member': memberController.text,
            'workingAtGov': workWithGov,
          },
          remark: {
            'firstName': nameController.text,
            'lastName': surnameController.text,
            'phone': telController.text,
            'office': workingController.text,
            'position': positionController.text,
          },
          kol: {
            'company': companyController.text,
            'product': productController.text,
          },
          benefits: benefitsController.text,
          other: otherController.text,
        );

        FireStoreService()
            .insertToFireStore(doctors.toMaps())
            .then((value) async {
          Navigator.of(context).pop();
          print('Insert Successfully');
          AlertProgress(context: context).showSuccessDialog();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }).catchError(
          (err) => print('Error==$err'),
        );

    }


  }
}