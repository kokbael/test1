import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// main.dart 에서 import '../style.dart' as style;
//  runApp(MaterialApp(
//       theme: style.theme,
//       debugShowCheckedModeBanner: false,
//       home: Authentication()));
// }

// primarySwatch 는 미리 제공되는 견본색상.
// 이외의 색 설정 필요 시 MaterialColor 인스턴스를 직접 생성해야 함. (https://points.tistory.com/65)

Color primaryColor = const Color(0xFF9575CD); //  Colors.deepPurple.shade300
// primary Color

var theme = ThemeData(
  brightness: Brightness.dark,
  // 상호작용 요소에 사용되는 색상

  primaryColor: Colors.amber,
  // // 앱의 주요부분 배경 색 (앱바, 탭바 등)

  appBarTheme: _appBarTheme(),
  // AppBarTheme
  // AppBarTheme 에서는 MaterialColor 를 사용하므로
  // Status Bar / AppBar 컬러 적용 시에 hex 코드로 사용 (ex.0xFF9575CD)

  bottomNavigationBarTheme: _bottomNavigationBarThemeData(),
  // BottomNavigationBarThemeData

  elevatedButtonTheme: ElevatedButtonThemeData(style: _evBtn()),
  // ElevatedButtonThemeData
  // style : _evBtn 에서 MaterialStateProperty 를 컨트롤하여
  // pressed, hovered, focused 마다 스타일 적용
  // backgroundColor: MaterialStateProperty.resolveWith((states) => _evBntColor(states)));

  textButtonTheme: _textButtonThemeData(),
  // TextButtonThemeData
  // styleFrom 은 ButtonStyle() 사본을 하나 생성해주는 함수
  // TextButton.styleFrom , ElevatedButton.styleFrom() ==> 버튼 내 텍스트 스타일 설정에 사용

  iconTheme: _iconThemeData(),
  // IconThemeData

  textTheme: TextTheme(
    headline6: dialogTitleStyle(),
  ),
  // headline6 => Dialog Title TextStyle
);

// 추가할 사항
// 1) fontFamily 설정
// 2) Decoration 속성도 하나의 파일로 모으기 (TextFormField, Container ...)
// 3) TextTheme 각 해당하는 위젯 정리 ( ex. headline6 => Dialog Title TextStyle )

// Function //

AppBarTheme _appBarTheme() {
  return AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD1C4E9),
    ),
    backgroundColor: primaryColor,
    centerTitle: true,
  );
}

BottomNavigationBarThemeData _bottomNavigationBarThemeData() {
  return BottomNavigationBarThemeData(
      //selected
      selectedIconTheme: IconThemeData(size: 25), // Icon Size
      selectedItemColor: Colors.deepPurple.shade400, // Icon Color
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Label Style
      // unselected
      unselectedIconTheme: IconThemeData(size: 22),
      unselectedItemColor: Colors.grey.shade400,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600));
}

ButtonStyle _evBtn() {
  return ButtonStyle(
      backgroundColor:
          MaterialStateProperty.resolveWith((states) => _evBntColor(states)));
}

Color _evBntColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.deepPurple.shade400;
  }
  return Colors.deepPurple.shade300;
}

TextButtonThemeData _textButtonThemeData() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.deepPurpleAccent, // textColor
      textStyle: TextStyle(fontWeight: FontWeight.bold),
      padding: EdgeInsets.all(5),
    ),
  );
}

// ElevatedButtonThemeData _elevatedButtonThemeData() {
//   return ElevatedButtonThemeData(style: ElevatedButton.styleFrom());
// }

IconThemeData _iconThemeData() {
  return IconThemeData(
    color: Colors.orange,
    size: 28,
  );
}

TextStyle dialogTitleStyle() {
  return TextStyle(
    fontWeight: FontWeight.w900,
    color: Colors.orange,
  );
}
