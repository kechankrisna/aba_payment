import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aba_payment/aba_payment.dart';

void main() {
  const MethodChannel channel = MethodChannel('aba_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
