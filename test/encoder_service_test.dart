// import 'package:flutter/services.dart';
import 'package:aba_payment/services/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // const MethodChannel channel = MethodChannel('aba_payment');

  TestWidgetsFlutterBinding.ensureInitialized();

  test("EncoderService.base46_encode and base46_decode map", () {
    List<Map<String, dynamic>> input = [
      {"name": "ទំនិញសាកល្បង", "quantity": 1, "price": 6}
    ];
    var encoded = EncoderService.base46_encode(input);
    print("encoded $encoded");
    var decoded = EncoderService.base46_decode(encoded);
    print("decoded $decoded");

    expect(input, decoded);
  });

  test("EncoderService.base46_encode and base46_decode String", () {
    final input = "ទំនិញសាកល្បង";
    var encoded = EncoderService.base46_encode(input);
    print("encoded $encoded");
    var decoded = EncoderService.base46_decode(encoded);
    print("decoded $decoded");

    expect(input, decoded);
  });

  test("EncoderService.base46_encode and base46_decode null", () {
    final input = null;
    var encoded = EncoderService.base46_encode(input);
    print("encoded $encoded");
    var decoded = EncoderService.base46_decode(encoded);
    print("decoded $decoded");

    expect(input, decoded);
  });
}
