

import 'dart:async';
import 'package:flutter/services.dart';

export 'model.dart';
export 'extension.dart';
export 'ui/aba_payment_widget.dart';

class AbaPayment {
  static const MethodChannel _channel =
      const MethodChannel('aba_payment');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
