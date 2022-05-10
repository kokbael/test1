import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key, this.setMainTab, this.mainTab})
      : super(key: key);
  final setMainTab;
  final mainTab;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.mainTab,
      onTap: (i) {
        setState(() {
          widget.setMainTab(i);
        });
      },
      // showSelectedLabels: false,
      // selectedIconTheme: IconThemeData(color: Colors.black),
      // unselectedIconTheme: IconThemeData(color: Colors.grey),
      items: const [
        BottomNavigationBarItem(
            label: 'home',
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(Icons.home)),
        BottomNavigationBarItem(
          label: 'create',
          icon: Icon(
            Icons.add,
          ),
        ),
        BottomNavigationBarItem(
          label: 'list',
          icon: Icon(
            Icons.list,
          ),
        ),
        BottomNavigationBarItem(
          label: 'court',
          icon: Icon(
            Icons.map,
          ),
        ),
      ],
    );
  }
}
