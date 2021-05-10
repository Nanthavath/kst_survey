import 'package:flutter/material.dart';
import 'package:kst_survey/screens/create_screen.dart';
import 'package:kst_survey/screens/summary_screen.dart';
import 'package:kst_survey/screens/update_screen.dart';

import 'home.dart';
import 'screens/logins/login_screen.dart';
import 'screens/pdf_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSansLao'
      ),
      debugShowCheckedModeBanner: false,
      title: 'KST-Doctor',
      // initialRoute:Home.route,
      // routes: {
      //   Home.route:(context)=>Home(),
      //   LoginScreen.route:(context)=>LoginScreen(),
      //   SummaryScreen.route:(context)=>SummaryScreen(),
      //   CreateScreen.route:(context)=>CreateScreen(),
      //   UpdateScreen.route:(context)=>UpdateScreen(),
      //
      // },
      home: PDFPage(),

    );
  }
}
