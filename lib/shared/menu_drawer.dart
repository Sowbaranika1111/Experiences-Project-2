import 'package:experiences_project/screens/sign_up_page.dart';
import 'package:flutter/material.dart';
import '../screens/intro_page.dart';
import '../screens/fav_page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: buildMenuItems(
              context) //the context is the same as BuildContext , which we recieve whenthe build method gets called
          ), //? ListView a scrollable list of widgets, it has a children parameter
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> menuTitles = [
      'Home',
      'Favourites',
      'My shared Experiences',
      "Create New Account"
    ];

    List<Widget> menuItems = [];
    menuItems.add(
      const DrawerHeader(
          decoration: BoxDecoration(color: Color.fromARGB(255, 191, 135, 219)),
          child: Text(
              '"When we share our stories, what it does is, it opens up our hearts for other people to share their stories. And it gives us the sense that we are not alone on this journey."\n - Janine Shepherd',
              style: TextStyle(color: Colors.white, fontSize: 15))),
    );

    for (var element in menuTitles) {
      Widget pages = Container();
      menuItems.add(ListTile(
        title: Text(element, style: const TextStyle(fontSize: 18)),
        onTap: () {
          switch (element) {
            case 'Home':
              pages = const IntroPage();
              break;
            case 'Favourites':
              pages = const FavPage();
              break;
            case 'Create New Account':
              pages = const SignUpPage();
              break;
          }
          //wheen we close the fav screen , the drawer opens again, to avoid this use pop() to remove remove drawer from the stack
          Navigator.of(context).pop();
          //to actually navigate to another screen , use navigator of the current context
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => pages));
        },
      ));
    }
    return menuItems;
  }
}
