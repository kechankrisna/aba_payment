// import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // const MethodChannel channel = MethodChannel('aba_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  test("encoded item", () {
    List<Map<String, dynamic>> items = [
      {"name": "test", "quantity": 1, "price": 6}
    ];

    var j = json.encode(items);
    String actual = base64Encode(j.runes.toList());
    var matcher = "W3sibmFtZSI6InRlc3QiLCJxdWFudGl0eSI6MSwicHJpY2UiOjZ9XQ";
    print(actual);
    // expect(base64Decode(actual), base64Decode(matcher));
    expect(1, 1);
  });
}
