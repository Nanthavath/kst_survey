

import 'package:flutter/material.dart';
import 'package:kst_survey/screens/create_screen.dart';
import 'package:kst_survey/screens/logins/login_screen.dart';
import 'package:kst_survey/screens/summary_screen.dart';
import 'package:kst_survey/screens/update_screen.dart';

import '../home.dart';

const String home='home';
const String login='login';
const String summary='summary';
const String update='update';
const String create='create';

Route<dynamic>controller(RouteSettings settings){
  if (settings.name==home) {
    return MaterialPageRoute(builder: (context)=>Home());
  }else if(settings.name==login){
    return MaterialPageRoute(builder: (context)=>LoginScreen());
  }else if (settings.name==summary) {
    return MaterialPageRoute(builder: (context)=>SummaryScreen());
  }else if(settings.name==create){
    return MaterialPageRoute(builder: (context)=>CreateScreen());
  }else if (settings.name==update) {
    return MaterialPageRoute(builder: (context)=>UpdateScreen());
  }
  throw('This route name does not exit');

}


