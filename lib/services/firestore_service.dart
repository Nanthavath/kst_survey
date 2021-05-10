import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// abstract class FireStoreServiceRepo{
//   Future<void>insertToFireStore(Map<String, dynamic>map);
// }
final CollectionReference doctor =
    FirebaseFirestore.instance.collection('Doctors');

class FireStoreService {
  Future<User> loginWithEmail({String email, String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw e.code;
    }
  }

  Future<void> insertToFireStore(Map<String, dynamic> map) async {
    return await doctor.add(map);
  }

  Future updateData(String docID, Map<String, dynamic> map) async {
    return await doctor.doc(docID).update(map);
  }

  Future<QuerySnapshot> fetchDoctorData() async {
    return await doctor.get();
  }


}
