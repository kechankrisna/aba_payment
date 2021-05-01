import 'package:flutter/material.dart';
import 'screens/cart_screen.dart';
import 'screens/webview_checkout.dart';

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
      initialRoute: "/",
      // themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      routes: {
        "/": (_) => CartScreen(),
      },
    );
  }
}
