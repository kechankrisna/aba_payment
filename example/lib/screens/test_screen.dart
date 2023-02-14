import 'package:aba_payment/aba_payment.dart';
import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/services/payway_transaction_service.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
      ),
      body: Column(
        children: [
          /// TextButton(
          ///   onPressed: () {
          ///     /// var serivce = PaywayTransactionService.instance!;
          ///     /// final tranID = "${DateTime.now().millisecond}";
          ///     /// final reqTime = "${DateFormat("yMddHms").format(DateTime.now())}";
          ///     /// var getHash = serivce.getHash(reqTime: reqTime, tranID: tranID);
          ///     /// print(getHash);
          ///   },
          ///   child: Text("getHash"),
          /// ),
          TextButton(
            onPressed: () async {
              final service = PaywayTransactionService.instance!;
              final reqTime = service.uniqueReqTime();
              final tranID = service.uniqueTranID();

              var _transaction = ABATransaction(
                merchant: service.merchant!,
                tranID: tranID,
                reqTime: reqTime,
                amount: 6.00,
                items: [
                  ABATransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
                  ABATransactionItem(name: "ទំនិញ 2", price: 2, quantity: 1),
                  ABATransactionItem(name: "ទំនិញ 3", price: 3, quantity: 1),
                ],
                email: 'support@mylekha.app',
                firstname: 'Miss',
                lastname: 'My Lekha',
                phone: '010464144',
                option: ABAPaymentOption.abapay_deeplink,
                shipping: 0.0,
                returnUrl: "https://stage.mylekha.app",
              );

              var result = await _transaction.create();
            },
            child: Text("createTransaction (old)"),
          ),
          TextButton(
            onPressed: () async {
              final service = PaywayTransactionService.instance!;
              final reqTime = service.uniqueReqTime();
              final tranID = service.uniqueTranID();

              var _transaction = PaywayCreateTransaction(
                  amount: 6.00,
                  items: [
                    PaywayTransactionItem(
                        name: "ទំនិញ 1", price: 1, quantity: 1),
                    PaywayTransactionItem(
                        name: "ទំនិញ 2", price: 2, quantity: 1),
                    PaywayTransactionItem(
                        name: "ទំនិញ 3", price: 3, quantity: 1),
                  ],
                  reqTime: reqTime,
                  tranId: tranID,
                  email: 'support@mylekha.app',
                  firstname: 'Miss',
                  lastname: 'My Lekha',
                  phone: '010464144',
                  option: ABAPaymentOption.abapay_deeplink,
                  shipping: 0.0,
                  returnUrl: "https://stage.mylekha.app");

              var response =
                  await service.createTransaction(transaction: _transaction);
              print(response.description);
            },
            child: Text("createTransaction (new)"),
          ),

          TextButton(
            onPressed: () async {
              final service = PaywayTransactionService.instance!;
              final reqTime = service.uniqueReqTime();
              final tranId = "1676362341086747";
              var _transaction =
                  PaywayCheckTransaction(tranId: tranId, reqTime: reqTime);
              var response =
                  await service.checkTransaction(transaction: _transaction);
              print(response.description);
            },
            child: Text("check transaction"),
          ),
          TextButton(
            onPressed: () async {
              final service = PaywayTransactionService.instance!;
              final reqTime = service.uniqueReqTime();
              final tranId = "1676267475638694";
              var _transaction =
                  PaywayCheckTransaction(tranId: tranId, reqTime: reqTime);
              var result = await service.isTransactionCompleted(
                  transaction: _transaction);
              print(result);
            },
            child: Text("validate transaction"),
          ),
          TextButton(
              onPressed: () async {
                String checkoutApiUrl =
                    "http://localhost/api/v1/integrate/payway/checkout_page";
                final service = PaywayTransactionService.instance!;
                final reqTime = service.uniqueReqTime();
                final tranID = service.uniqueTranID();

                var _transaction = PaywayCreateTransaction(
                    amount: 6.00,
                    items: [
                      PaywayTransactionItem(
                          name: "ទំនិញ 1", price: 1, quantity: 1),
                      PaywayTransactionItem(
                          name: "ទំនិញ 2", price: 2, quantity: 1),
                      PaywayTransactionItem(
                          name: "ទំនិញ 3", price: 3, quantity: 1),
                    ],
                    reqTime: reqTime,
                    tranId: tranID,
                    email: 'support@mylekha.app',
                    firstname: 'Miss',
                    lastname: 'My Lekha',
                    phone: '010464144',
                    option: ABAPaymentOption.abapay,
                    shipping: 0.00,
                    returnUrl: "https://stage.mylekha.app");
                var uri = await service.generateTransactionCheckoutURI(
                  transaction: _transaction,
                  checkoutApiUrl: checkoutApiUrl,
                );
                print("url ${uri}");
              },
              child: Text("generante uri"))
        ],
      ),
    );
  }
}
