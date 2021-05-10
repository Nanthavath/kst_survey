class Doctor {
  String firstName;
  String lastName;
  String gender;
  String birthDay;
  String currentPosition;
  String office;
  String currentVillage;
  String phone;
  String email;
  List technical;
  String teachAt;
  List connection;
  List familyBusiness;
  Map<String, dynamic> personal;
  Map<String, dynamic> familys;
  Map<String, dynamic> remark;
  Map<String, dynamic> kol;
  String benefits;
  String other;
  String img;

  Doctor({
    this.firstName,
    this.lastName,
    this.gender,
    this.birthDay,
    this.currentPosition,
    this.office,
    this.currentVillage,
    this.phone,
    this.email,
    this.technical,
    this.teachAt,
    this.familys,
    this.connection,
    this.familyBusiness,
    this.personal,
    this.remark,
    this.kol,
    this.benefits,
    this.other,
    this.img,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) => Doctor(
        firstName: map['firstName'],
        lastName: map['lastName'],
        gender: map['gender'],
        birthDay: map['birthDay'],
        currentPosition: map['currentPosition'],
        office: map['office'],
        currentVillage: map['currentVillage'],
        phone: map['phone'],
        email: map['email'],
        technical: map['technical'],
        teachAt: map['teachAt'],
        connection: map['connectionWith'],
        familyBusiness: map['familyBusiness'],
        personal: map['personal'],
        familys: map['family'],
        remark: map['remark'],
        kol: map['kol'],
        benefits: map['benefits'],
        other: map['other'],
        img: map['img'],
      );

  Map<String, dynamic> toMaps() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDay': birthDay,
      'currentPosition': currentPosition,
      'office': office,
      'currentVillage': currentVillage,
      'phone': phone,
      'email': email,
      'technical': technical,
      'teachAt': teachAt,
      'connectionWith': connection,
      'familyBusiness': familyBusiness,
      'personal': personal,
      'family': familys,
      'remark': remark,
      'kol': kol,
      'benefits': benefits,
      'other': other,
      'img': img,
    };
  }
}
