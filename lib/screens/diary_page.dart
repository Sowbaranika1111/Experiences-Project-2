import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/shared/menu_bottom.dart';
import 'package:experiences_project/shared/menu_drawer.dart';
import 'package:flutter/material.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 191, 135, 219),
        title: const Text("How Was Your Conscious Breath Journey Today?"),
      ),
      drawer: const MenuDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(), 
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Floating============");
          if (context.mounted) {
            Navigator.of(context).pushNamed('/diaryWriting');
          }
        },
        backgroundColor: Pallete.appBar,
        child: const Icon(Icons.notes_sharp),
      ),
      bottomNavigationBar: const MenuBottom(
        backgroundColor: Color.fromARGB(255, 191, 135, 219),
        currentIndex: 2,
      ),
    );
  }
}