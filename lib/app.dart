import 'package:flutter/material.dart';
import 'package:seach_bar_test_app/res/res.dart';
import 'package:seach_bar_test_app/screens/search_screen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.AppName,
      home: SearchScreen (),
    );
  }
}