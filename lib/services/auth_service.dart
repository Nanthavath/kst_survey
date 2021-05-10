import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  FirebaseAuth _auth=FirebaseAuth.instance;
  Future<User> loginWithEmail({String email, String password}) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
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
  Future<void>logOut()async{
    return await _auth.signOut();
  }

}