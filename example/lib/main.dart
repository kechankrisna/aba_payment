import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ABA Payment Testing",
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      routes: {
        "/": (_) => CartScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
