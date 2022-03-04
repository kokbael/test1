import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          label: 'back',
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: 'home',
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: 'menu',
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        BottomNavigationBarItem(
          label: 'setting',
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
