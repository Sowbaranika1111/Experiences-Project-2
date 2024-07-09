import 'package:flutter/material.dart';

class MenuBottom extends StatelessWidget {

  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final int currentIndex;

  const MenuBottom({
    super.key,
    this.backgroundColor = const Color.fromARGB(255, 193, 111, 235),
    this.selectedItemColor =  Colors.black,
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
      onTap:(int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/fav');
            break;
          case 3:
            Navigator.pushNamed(context, '/diary');
            break;
          case 4:
            Navigator.pushNamed(context, '/grateful');
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
            size: 24.0,
          ),
          label: 'Add Yours',
        ),
    
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border_outlined,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 24.0,
            ),
            label: 'Favourites',
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
            Icons.handshake_rounded,
            // color: Color.fromARGB(255, 193, 111, 235),
            size: 24.0,
            ),
            label: 'Gratitude',
          )
      ],
      // selectedItemColor: Colors.grey,
      // unselectedItemColor: const Color.fromARGB(255, 193, 111, 235),
    );
  }
}
