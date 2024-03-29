// import 'package:flutter/services.dart';

import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/models/models.dart';
import 'package:aba_payment/services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io' as io;

void main() {
  group("load env and test", () {
    setUpAll(() {
      io.HttpOverrides.global = null;

      dotenv.testLoad(fileInput: io.File('.env').readAsStringSync());

      PaywayTransactionService.ensureInitialized(ABAMerchant(
        merchantID: dotenv.get('ABA_PAYWAY_MERCHANT_ID'),
        merchantApiName: dotenv.get('ABA_PAYWAY_MERCHANT_NAME'),
        merchantApiKey: dotenv.get('ABA_PAYWAY_API_KEY'),
        baseApiUrl: dotenv.get('ABA_PAYWAY_API_URL'),
        refererDomain: "http://mylekha.app",
      ));
    });

    test("create a transaction then check status pending", () async {
      final service = PaywayTransactionService.instance!;
      final tranID = service.uniqueTranID();

      var _transaction = PaywayCreateTransaction(
          amount: 6.00,
          items: [
            PaywayTransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
            PaywayTransactionItem(name: "ទំនិញ 2", price: 2, quantity: 1),
            PaywayTransactionItem(name: "ទំនិញ 3", price: 3, quantity: 1),
          ],
          reqTime: service.uniqueReqTime(),
          tranId: tranID,
          email: 'support@mylekha.app',
          firstname: 'Miss',
          lastname: 'My Lekha',
          phone: '010464144',
          option: ABAPaymentOption.abapay_deeplink,
          shipping: 0.0,
          returnUrl: "https://stage.mylekha.app");

      var createResponse =
          await service.createTransaction(transaction: _transaction);

      expect(createResponse.abapayDeeplink != null, true,
          reason: "the deeplink should be a string according to docs");

      var checkResponse = await service.checkTransaction(
          transaction: PaywayCheckTransaction(
        tranId: _transaction.tranId,
        reqTime: service.uniqueReqTime(),
      ));

      expect(checkResponse.status == 2, true,
          reason: "the new transaction created should be pending or status 2");
    });

    test("generate checkout uri for a transaction then check status pending",
        () async {
      final service = PaywayTransactionService.instance!;
      final tranID = service.uniqueTranID();

      var _transaction = PaywayCreateTransaction(
          amount: 6.00,
          items: [
            PaywayTransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
            PaywayTransactionItem(name: "ទំនិញ 2", price: 2, quantity: 1),
            PaywayTransactionItem(name: "ទំនិញ 3", price: 3, quantity: 1),
          ],
          reqTime: service.uniqueReqTime(),
          tranId: tranID,
          email: 'support@mylekha.app',
          firstname: 'Miss',
          lastname: 'My Lekha',
          phone: '010464144',
          option: ABAPaymentOption.abapay_deeplink,
          shipping: 0.0,
          returnUrl: "https://stage.mylekha.app");
      String checkoutApiUrl =
          "http://localhost/api/v1/integrate/payway/checkout_page";
      var webURI = await service.generateTransactionCheckoutURI(
          transaction: _transaction, checkoutApiUrl: checkoutApiUrl);

      expect(
          webURI.queryParameters['items'],
          EncoderService.base46_encode(
              _transaction.items.map((e) => e.toMap()).toList()),
          reason: "encoded items should be equal");

      expect(webURI.authority.isNotEmpty, true,
          reason: "the uri should be generated");
    });
  });
}
