import 'package:aba_payment/aba_payment.dart';
import 'package:aba_payment/model/aba_mechant.dart';

final ABAMerchant merchant = ABAMerchant(
  merchantID: "mylekha",
  merchantApiName: "pwmylekham",
  merchantApiKey: "cea2a8308c634a458b983def9303781f",
  baseApiUrl: "https://payway-staging.ababank.com",
  refererDomain: "http://localhost"
);
