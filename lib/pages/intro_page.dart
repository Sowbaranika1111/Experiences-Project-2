import 'package:experiences_project/shared/menu_drawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 191, 135, 219),
        title: const Text("Tell Your Tale"),
        centerTitle: true,
      ),
      drawer: const MenuDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap:(int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/');
              break;
            case 2:
              Navigator.pushNamed(context, '/fav');
              break;
            case 3:
              Navigator.pushNamed(context, '/');
              break;
            case 4:
              Navigator.pushNamed(context, '/');
              break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 193, 111, 235),
              size: 24.0,
            ),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.videocam_outlined,
              color: Color.fromARGB(255, 193, 111, 235),
              size: 24.0,
            ),
            label: 'Add yours'
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 193, 111, 235),
              size: 24.0,
              ),
              label: 'Favourites'
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note_alt_rounded,
              color: Color.fromARGB(255, 193, 111, 235),
              size: 24.0,
              ),
              label: 'Everyday experiences'
            ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.handshake_rounded,
              color: Color.fromARGB(255, 193, 111, 235),
              size: 24.0,
              ),
              label: 'Gratitude'
            )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/home_pg_img.jpg'),
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
