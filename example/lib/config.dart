import 'package:aba_payment/aba_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final ABAMerchant merchant = ABAMerchant(
  merchantID: dotenv.get('ABA_PAYWAY_MERCHANT_ID'),
  merchantApiName: dotenv.get('ABA_PAYWAY_MERCHANT_NAME'),
  merchantApiKey: dotenv.get('ABA_PAYWAY_API_KEY'),
  baseApiUrl: dotenv.get('ABA_PAYWAY_API_URL'),
  refererDomain: "https://mylekha.app",
);
