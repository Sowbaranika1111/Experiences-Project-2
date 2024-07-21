import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/add_yours_page.dart';
import 'package:experiences_project/screens/diary_page.dart';
import 'package:experiences_project/screens/fav_page.dart';
import 'package:experiences_project/screens/gratitude_page.dart';
import 'package:experiences_project/screens/intro_page.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:experiences_project/screens/profile_page.dart';
import 'package:experiences_project/screens/sign_up_page.dart';
import 'package:experiences_project/widgets/diary_writing.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const ExpApp());
}

class ExpApp extends StatelessWidget {
  const ExpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: Pallete.backgroundColorFullApp),
      routes: {
        '/': (context) => const IntroPage(),
        '/register': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/addyours': (context) => const AddYoursPage(),
        '/fav': (context) => const FavPage(),
        '/diary': (context) => const DiaryPage(),
        '/diaryWriting': (context) => const DiaryWritingField(),
        '/grateful': (context) => const GratitudePage(),
        '/profile': (context) => const ProfilePage(),
      },
      initialRoute: '/',
      // home:const IntroPage() //if we set the initial route , we can't set the home also , so remove it
    );
  }
}
