import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/widgets/exp_display_field.dart';
import 'package:flutter/material.dart';
import '../shared/menu_drawer.dart';
import '../shared/menu_bottom.dart';
// import 'package:experiences_project/widgets/category_scrolling.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.appBar,
        title: const Text("Tell Your Tale"),
        centerTitle: true,
      ),
      drawer: const MenuDrawer(),
      bottomNavigationBar: const MenuBottom(
        backgroundColor: Pallete.appBar,
        currentIndex: 0,
      ),
      backgroundColor: Colors.white,
      body: const Column(
        children: [
          Expanded(child: ExpDisplayField()),
        ],
      ),
    );
  }
}









// body: Container(
//         child: ListView(
//           children: const [
//             // CategoryScrollingSection(),
//             // SizedBox(height: 20),
//             ExpDisplayField(),
//           ],
//         ),
//       ),
