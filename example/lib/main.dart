import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'screens/cart_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
