import 'package:experiences_project/pages/fav_page.dart';
import 'package:experiences_project/pages/intro_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpApp());
}

class ExpApp extends StatelessWidget {
  const ExpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      routes : {
        '/' : (context) => const IntroPage(),
        '/fav' : (context) => const FavPage(),
      },
      initialRoute: '/',
      // home:const IntroPage() //if we set the initial route , we can't set the home also , so remove it
      );
  }
}
