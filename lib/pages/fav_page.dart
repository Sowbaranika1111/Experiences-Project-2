import "package:experiences_project/shared/menu_drawer.dart";
import "package:flutter/material.dart";

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My favourites')),
      drawer: const MenuDrawer(), //! to bring drawer in this page 
      body: const Center(child: FlutterLogo()),
    );
  }
}
