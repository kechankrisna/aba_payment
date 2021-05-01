import 'dart:io';

import 'package:aba_payment/aba_payment.dart';
import 'package:aba_payment_example/models/item_model.dart';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import 'checkout_browser.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ABATransaction _transaction = ABATransaction.instance(merchant);
  List<ItemModel> _items = [];
  File _file;
  String _path;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    _items = [
      ItemModel(name: "item 1", price: 1, quantity: 1),
      ItemModel(name: "item 2", price: 2, quantity: 2),
      ItemModel(name: "item 3", price: 3, quantity: 3),
    ];

    _transaction.amount = 1.0;
    _transaction.firstname = "Mr.";
    _transaction.lastname = "Customer";
    _transaction.phone = "010464144";
    _transaction.email = "admin@mylekha.app";
    _transaction.items = [..._items.map((e) => e.toMap()).toList()];

    _path =
        p.join((await getApplicationDocumentsDirectory()).path, "payment.html");
    _file = File(_path);
  }

  double get total =>
      _items.fold(0, (prev, e) => prev += (e.price * e.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YOUT CARTS (${_items.length})"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._items.map(
                  (item) => ListTile(
                    title: Text("${item.name}"),
                    subtitle: Text("price: x${item.price}"),
                    trailing: Text("${item.quantity}"),
                  ),
                ),
              ],
            ),
          ),
          ABAPaymentWidget(
            value: _transaction.paymentOption,
            onChanged: (v) => setState(() => _transaction.paymentOption = v),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _onCheckout, child: Text("check out ($total)")),
            ),
          )
        ],
      ),
    );
  }

  _onCheckout() async {
    setState(() {
      _transaction.amount = total;
    });

    var map = _transaction.toMap();
    var apiUrl = "${merchant.baseApiUrl}/api/${merchant.merchantApiName}";
    map["apiUrl"] = apiUrl;
    _file.writeAsStringSync(generateCheckoutContent());
    print(_file.path);
    // var _browser = CheckoutBrowser();
    // _browser.openUrlRequest(
    //   urlRequest: URLRequest(
    //     url: Uri.file(_file.path),
    //     headers: {
    //       "Referer": "https://mylekha.app",
    //       "referer": "https://mylekha.app",
    //     },
    //     method: "GET",
    //   ),
    // );
    launch(
      "file://${Uri.file(_file.path).path}",
    );
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => WebViewCheckoutScreen(value: _file.path)));
    // var result = await _transaction.create();

    // if (result.status < 5) {
    //   if (result.rawcontent != null) {
    //     /// [open up webview]
    //   } else {
    //     /// [open native using deeplink]
    //     if (Platform.isIOS) {
    //       if (await canLaunch(result.abapayDeeplink)) {
    //         await launch(result.abapayDeeplink);
    //       } else {
    //         await launch(result.appStore);
    //       }
    //     } else if (Platform.isAndroid) {
    //       if (await canLaunch(result.abapayDeeplink)) {
    //         await launch(result.abapayDeeplink);
    //       } else {
    //         await launch(result.playStore);
    //       }
    //     }
    //   }
    // } else {
    //   print("Error ${result.description}");
    // }
  }

  generateCheckoutContent() {
    return """
<!DOCTYPE html>
<html lang="en">

<head>

    <!— Make a copy of this code to paste into your site—>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="author" content="PayWay">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <!— end —>
</head>

<body>
<!— Popup Checkout Form —>
<div id="aba_main_modal" class="aba-modal">
    <!— Modal content —>
    <div class="aba-modal-content">
        <form method="POST" target="aba_webservice" action="https://payway-staging.ababank.com/api/pwmylekham/" id="aba_merchant_request">
            <input type="hidden" name="hash" value="${_transaction.hash}" id="hash"/>
            <input type="hidden" name="tran_id" value="${_transaction.tranID}" id="tran_id"/>
            <input type="hidden" name="amount" value="${_transaction.amount}" id="amount"/>
            <input type="hidden" name="firstname" value="${_transaction.firstname}"/>
            <input type="hidden" name="lastname" value="${_transaction.lastname}"/>
            <input type="hidden" name="phone" value="${_transaction.phone}"/>
            <input type="hidden" name="email" value="${_transaction.email}"/>
            <input type="hidden" name="payment_option" value="${_transaction.paymentOption.toText}"/>
        </form>
        <iframe scrolling="yes" class="aba-iframe " src="" name="aba_webservice" id="aba_webservice"></iframe>
    </div>
    <!— end Modal content—>
</div>
<!— End Popup Checkout Form —>

<!— Page Content —>
<div class="container" style="margin-top: 75px;margin: 0 auto;">
    <div style="width: 200px;margin: 0 auto;">
        <h2>TOTAL: ${_transaction.amount}</h2>
        <input type="button" id="checkout_button" value="Checkout Now">
    </div>
</div>
<!— End Page Content —>

<!— Make a copy this javaScript to paste into your site—>
<!— Note: these javaScript files are using for only integration testing—>
<link rel="stylesheet" href="https://payway-staging.ababank.com/checkout-popup.html?file=css"/>
<script src="https://payway-staging.ababank.com/checkout-popup.html?file=js"></script>

<!— These javaScript files are using for only production —>
<!--<link rel="stylesheet" href="https://payway.ababank.com/checkout-popup.html?file=css"/>
<script src="https://payway.ababank.com/checkout-popup.html?file=js"></script> -->

<script>
    \$(document).ready(function(){
        AbaPayway.checkout();
    });
</script>

<!— End —>
</body>
</html>    
    """;
  }
}
