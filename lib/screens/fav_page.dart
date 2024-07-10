import "package:flutter/material.dart";
import "package:experiences_project/shared/menu_bottom.dart";
import "package:experiences_project/shared/menu_drawer.dart";

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My favourites'),
        backgroundColor: const Color.fromARGB(255, 191, 135, 219),
      ),
      bottomNavigationBar: const MenuBottom(
        backgroundColor: Color.fromARGB(255, 191, 135, 219),
        currentIndex: 2,
      ),
      drawer: const MenuDrawer(), //! to bring drawer in this page
      body: const Center(child: FlutterLogo()),
    );
  }
}
