import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColor = const Color(0xFF9575CD);
//  Colors.deepPurple.shade300

var theme = ThemeData(
  // brightness: Brightness.dark,
  // primaryColor: Colors.amber,
  appBarTheme: _appBarTheme(),
  bottomNavigationBarTheme: _bottomNavigationBarThemeData(),
  elevatedButtonTheme: _elevatedButtonThemeData(),
  textButtonTheme: _textButtonThemeData(),
  iconTheme: _iconThemeData(),
  textTheme: _textTheme(),
);

// InputDecorationTheme inputDecorationTheme() {
//   return InputDecorationTheme();
// }

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0x5F5F5F5F),
    ),
    backgroundColor: primaryColor,
    //centerTitle: true,
    elevation: 0,
  );
}

BottomNavigationBarThemeData _bottomNavigationBarThemeData() {
  return BottomNavigationBarThemeData(
      backgroundColor: Colors.white,

      //selected
      selectedIconTheme: IconThemeData(size: 25), // Icon Size
      selectedItemColor: Colors.deepPurple.shade300, // Icon Color
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Label Style
      // unselected
      unselectedIconTheme: IconThemeData(size: 22),
      unselectedItemColor: Colors.grey.shade300,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600));
}

ElevatedButtonThemeData _elevatedButtonThemeData() {
  return ElevatedButtonThemeData(style: _evBtn());
}

ButtonStyle _evBtn() {
  return ButtonStyle(
    backgroundColor:
        MaterialStateProperty.resolveWith((states) => _evBntColor(states)),
    textStyle:
        MaterialStateProperty.resolveWith((states) => _evBntTextStyle(states)),
    foregroundColor:
        MaterialStateProperty.resolveWith((states) => _evBntTextColor(states)),
    elevation: MaterialStateProperty.all<double>(5),
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
  );
}

Color _evBntColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.deepPurpleAccent;
  }
  return Colors.deepPurple.shade300;
}

TextStyle _evBntTextStyle(Set<MaterialState> states) {
  if (states.contains(MaterialState.pressed)) {
    return TextStyle(fontWeight: FontWeight.bold);
  } else {
    return TextStyle();
  }
}

Color _evBntTextColor(Set<MaterialState> states) {
  if (states.contains(MaterialState.pressed)) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

TextButtonThemeData _textButtonThemeData() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.deepPurpleAccent, // textColor
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      padding: EdgeInsets.all(5),
      // tapTargetSize: MaterialTapTargetSize.shrinkWrap
    ),
  );
}

IconThemeData _iconThemeData() {
  return IconThemeData(
    color: Colors.deepPurple.shade300,
    size: 18,
  );
}

TextTheme _textTheme() {
  return TextTheme(
    headline6: _dialogTitleStyle(),
  );
}

TextStyle _dialogTitleStyle() {
  return TextStyle(fontWeight: FontWeight.w900, color: Colors.orange);
}

// ButtonStyle _textBtn() {
//   return ButtonStyle(
//       side: MaterialStateProperty.all(
//           BorderSide(width: 0.5, color: Colors.deepOrange)),
//       foregroundColor: MaterialStateProperty.all(Colors.black),
//       textStyle:
//       MaterialStateProperty.all(TextStyle(fontWeight: FontWeight.bold)),
//       padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
//       elevation: MaterialStateProperty.all<double>(1.0),
//       backgroundColor: MaterialStateProperty.resolveWith((states) {
//         if (states.contains(MaterialState.pressed)) {
//           return Color.fromARGB(255, 255, 183, 163);
//         } else {
//           return Colors.white;
//         }
//       }),
//       shape: MaterialStateProperty.resolveWith((states) {
//         if (states.contains(MaterialState.pressed)) {
//           return RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10));
//         } else {
//           return null;
//         }
//       }));
// }
