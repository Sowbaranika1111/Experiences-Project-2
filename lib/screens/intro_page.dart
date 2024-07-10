import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';
import '../shared/menu_drawer.dart';
import '../shared/menu_bottom.dart';
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

      bottomNavigationBar:const MenuBottom(
              backgroundColor:  Pallete.bottomNavigationBar,
              currentIndex: 0,
      ),
      backgroundColor: Pallete.bottomNavigationBar,

      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/home_pg_img.jpg'),
                  fit: BoxFit.cover)),
          child: Center(
              child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white70),
                  child: const Text(
                    "Listen Share Evolve",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, shadows: [
                      Shadow(offset: Offset(1.0, 1.0), blurRadius: 1.0)
                    ]),
                  )
                  )
                  )
                  ),
    );
  }
}

