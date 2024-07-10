import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/diary_page.dart';
import 'package:experiences_project/screens/fav_page.dart';
import 'package:experiences_project/screens/gratitude_page.dart';
// import 'package:experiences_project/screens/intro_page.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpApp());
}

class ExpApp extends StatelessWidget {
  const ExpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColorLoginPg
      ),
      routes : {
        '/' : (context) => const LoginPage(),
        '/fav' : (context) => const FavPage(),
        '/diary': (context) => const DiaryPage(),
        '/grateful': (context) => const GratitudePage(),
      },
      initialRoute: '/',
      // home:const IntroPage() //if we set the initial route , we can't set the home also , so remove it
      );
  }
}
