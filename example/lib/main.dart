import 'package:aba_payment/aba_payment.dart';
import 'package:aba_payment/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'screens/cart_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  PaywayTransactionService.ensureInitialized(ABAMerchant(
    merchantID: dotenv.get('ABA_PAYWAY_MERCHANT_ID'),
    merchantApiName: dotenv.get('ABA_PAYWAY_MERCHANT_NAME'),
    merchantApiKey: dotenv.get('ABA_PAYWAY_API_KEY'),
    baseApiUrl: dotenv.get('ABA_PAYWAY_API_URL'),
    refererDomain: "https://mylekha.app",
  ));
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
        "/": (_) => TestScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
