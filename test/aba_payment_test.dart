import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aba_payment/aba_payment.dart';

void main() {
  const MethodChannel channel = MethodChannel('aba_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AbaPayment.platformVersion, '42');
  });
}
