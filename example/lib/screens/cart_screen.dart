import 'package:aba_payment/aba_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../config.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  ABAMerchant _merchant = merchant;
  double _total = 6.00;
  double _shipping = 0.0;
  String _firstname = "Miss";
  String _lastname = "My Lekha";
  String _phone = "010464144";
  String _email = "support@mylekha.app";
  String _checkoutApiUrl =
      "http://localhost/api/v1/integrate/payway/checkout_page";
  List<ABATransactionItem> _items = [];

  initialize() {
    if (mounted) {
      setState(() {
        _total = 6.00;
        _shipping = 0.0;
        _firstname = "Miss";
        _lastname = "My Lekha";
        _phone = "010464144";
        _email = "support@mylekha.app";
        _items = [
          ABATransactionItem(name: "item 1", price: 1, quantity: 1),
          ABATransactionItem(name: "item 2", price: 2, quantity: 1),
          ABATransactionItem(name: "item 3", price: 3, quantity: 1),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

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
                    subtitle: Text("price: x${item.price}\$"),
                    trailing: Text("${item.quantity}"),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ABACheckoutContainer(
            amount: _total,
            shipping: _shipping,
            firstname: _firstname,
            lastname: _lastname,
            email: _email,
            phone: _phone,
            items: _items,
            checkoutApiUrl: _checkoutApiUrl,
            merchant: _merchant,
            onBeginCheckout: (transaction) {
              setState(() => _isLoading = true);
              EasyLoading.show(status: 'loading...');
            },
            onFinishCheckout: (transaction) {
              setState(() => _isLoading = false);
              EasyLoading.dismiss();
            },
            onBeginCheckTransaction: (transaction) {
              setState(() => _isLoading = true);
              EasyLoading.show(status: 'loading...');
              print("onBeginCheckTransaction ${transaction.toMap()}");
            },
            onFinishCheckTransaction: (transaction) {
              setState(() => _isLoading = false);

              EasyLoading.dismiss();
              print("onFinishCheckTransaction ${transaction.toMap()}");
            },
            enabled: !_isLoading,
            // onPaymentFail: (transaction) {
            //   print("onPaymentFail ${transaction.toMap()}");
            // },
            onPaymentSuccess: (transaction) {
              print("onPaymentSuccess ${transaction.toMap()}");
            },
          ),
        ],
      ),
    );
  }
}
