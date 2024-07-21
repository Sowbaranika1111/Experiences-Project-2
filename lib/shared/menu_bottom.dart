import 'package:flutter/material.dart';

class MenuBottom extends StatelessWidget {
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final int currentIndex;

  const MenuBottom({
    super.key,
    this.backgroundColor = const Color.fromARGB(255, 193, 111, 235),
    this.selectedItemColor = Colors.black,
    this.unselectedItemColor = Colors.white,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      currentIndex: currentIndex,

      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/addyours');
            break;
          case 2:
            Navigator.pushNamed(context, '/diary');
            break;
          case 3:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 24.0,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.videocam_outlined,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 26.0,
          ),
          label: 'Add Yours',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.note_alt_rounded,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 24.0,
          ),
          label: 'Diary',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_pin,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 24.0,
          ),
          label: 'Profile',
        ),
      ],
      // selectedItemColor: Colors.grey,
      // unselectedItemColor: const Color.fromARGB(255, 193, 111, 235),
    );
  }
}
