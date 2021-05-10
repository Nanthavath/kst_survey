import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kst_survey/screens/summary_screen.dart';
import 'screens/logins/login_screen.dart';

class Home extends StatelessWidget {
  static String route = '/';
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth.instance.authStateChanges().listen((User user) {
            if (user == null) {
              Navigator.of(context).pushNamed(LoginScreen.route);
              return LoginScreen();
            } else {
              Navigator.of(context).pushNamed(SummaryScreen.route);
            }
          });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
