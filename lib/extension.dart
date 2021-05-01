import 'enumeration.dart';

extension AcceptPaymentOptionParsing on AcceptPaymentOption {
  /// [toText] convert this enumber to text
  String get toText => toString().split(".").last;
}

extension StringParsing on String {
  /// [fromText] conver text to enum AcceptPaymentOption
  AcceptPaymentOption get toAcceptPaymentOption {
    switch (this) {
      case "cards":
        return AcceptPaymentOption.cards;
        break;
      case "abapay":
        return AcceptPaymentOption.abapay;
        break;
      case "abapay_deeplink":
        return AcceptPaymentOption.abapay_deeplink;
        break;
      default:
        return AcceptPaymentOption.cards;
    }
  }
}
