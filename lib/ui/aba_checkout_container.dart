import 'dart:io';
import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/model.dart';
import 'package:aba_payment/ui/aba_checkout_success.dart';
import 'package:aba_payment/ui/aba_checkout_webview.dart';
import 'package:flutter/material.dart';
import 'package:aba_payment/model/aba_transaction.dart';
import 'package:aba_payment/ui/aba_payment_lists.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

/// ## `ABACheckoutContainer`
/// A completed widget which allow user intergrate ABA Payment into their flutter app easily
/// ### `@required parameter`
/// ```
/// amount: double
/// firstname: String
/// lastname: String
/// email: String
/// phone: String
/// checkoutApiUrl : String
/// merchant: ABAMerchant
/// ```
class ABACheckoutContainer extends StatefulWidget {
  final double amount;
  final double shipping;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final List<Map<String, dynamic>> items;
  final String checkoutApiUrl;
  final ABAMerchant merchant;
  final Function(ABATransaction transaction) onBeginCheckout;
  final Function(ABATransaction transaction) onFinishCheckout;
  final Function(ABATransaction transaction) onBeginCheckTransaction;
  final Function(ABATransaction transaction) onFinishCheckTransaction;
  final Function(int value, String msg) onCreatedTransaction;
  final Function(ABATransaction transaction) onPaymentSuccess;
  final Function(ABATransaction transaction) onPaymentFail;
  final bool enabled;

  const ABACheckoutContainer({
    Key key,
    @required this.amount,
    @required this.shipping,
    @required this.lastname,
    @required this.firstname,
    @required this.email,
    @required this.phone,
    this.items = const [],
    @required this.checkoutApiUrl,
    @required this.merchant,
    this.onBeginCheckout,
    this.onFinishCheckout,
    this.onBeginCheckTransaction,
    this.onFinishCheckTransaction,
    this.onCreatedTransaction,
    this.onPaymentSuccess,
    this.onPaymentFail,
    this.enabled: false,
  })  : assert(amount > 0),
        assert(lastname != null),
        assert(firstname != null),
        assert(email != null),
        assert(phone != null),
        assert(checkoutApiUrl != null),
        assert(merchant != null),
        super(key: key);
  @override
  _ABACheckoutContainerState createState() => _ABACheckoutContainerState();
}

class _ABACheckoutContainerState extends State<ABACheckoutContainer>
    with WidgetsBindingObserver {
  bool _requiredCheck = false;
  ABATransaction _transaction;
  String _error;

  @override
  void initState() {
    _transaction = ABATransaction.instance(widget.merchant);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_requiredCheck) {
          _checkTransaction();
        }
        ABAPayment.logger("didChangeAppLifecycleState _onResume()");
        break;
      default:
        ABAPayment.logger("didChangeAppLifecycleState $state");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ABAPaymentLists(
            value: _transaction.paymentOption,
            onChanged: (v) => setState(() => _transaction.paymentOption = v),
          ),
          if (_error != null)
            Container(
              child: Text(
                "$_error",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          Container(
            padding: themeData.buttonTheme.padding,
            child: ElevatedButton(
              onPressed: !widget.enabled ? null : _onBeginCheckout,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  "checkout",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ## `update transaction`
  /// This event will be trigger to ensure transaction property is corrected.
  _updateTransaction() {
    if (mounted) {
      setState(() {
        _transaction.amount = widget.amount;
        _transaction.firstname = widget.firstname;
        _transaction.lastname = widget.lastname;
        _transaction.email = widget.email;
        _transaction.phone = widget.phone;
        _transaction.shipping = widget.shipping;
        _transaction.items = widget.items;
      });
    }
  }

  /// ## `onCheckOut`
  /// This event will be triggered whenever user pressed checkout button
  _onBeginCheckout() async {
    _updateTransaction();
    widget.onBeginCheckout?.call(_transaction);

    if (_transaction.paymentOption == AcceptPaymentOption.abapay_deeplink) {
      var result = await _transaction.create();
      widget.onFinishCheckout?.call(_transaction);
      ABAPayment.logger(result.toMap());
      if (result.status < 5) {
        widget.onCreatedTransaction?.call(result.status, result.description);

        /// [open native using deeplink]
        if (result.abapayDeeplink != null) {
          if (await canLaunch(result.abapayDeeplink)) {
            setState(() => _requiredCheck = true);
            await launch(result.abapayDeeplink);
          } else {
            if (Platform.isIOS) {
              await launch(result.appStore);
            } else if (Platform.isAndroid) {
              await launch(result.playStore);
            }
          }
        } else {
          Fluttertoast.showToast(msg: "error deeplink");
        }
      } else {
        Fluttertoast.showToast(msg: "${result.description}");
      }
    } else if (_transaction.paymentOption == AcceptPaymentOption.cards ||
        _transaction.paymentOption == AcceptPaymentOption.abapay) {
      var map = _transaction.toMap();
      var parsed = Uri.tryParse(widget.checkoutApiUrl);
      assert(parsed != null);
      Uri uri;

      /// `check if domain name contain https`
      if (parsed.authority.contains("https")) {
        uri = Uri.https(parsed.authority, parsed.path, map);
      } else {
        uri = Uri.http(parsed.authority, parsed.path, map);
      }
      widget.onFinishCheckout?.call(_transaction);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ABACheckoutWebView(uri: uri, merchant: widget.merchant)));

      _checkTransaction();
    }
  }

  /// ## `_checkTransaction`
  /// This method will be triggerd after user back from webview checkout or
  /// aba mobile checkout. It will let user know if current transaction was paid successfully or failed
  _checkTransaction() async {
    widget.onBeginCheckTransaction?.call(_transaction);
    ABAPayment.logger("===== begin checking transaction =====");
    var check = await _transaction.check();
    setState(() => _requiredCheck = false);
    widget.onFinishCheckTransaction?.call(_transaction);
    ABAPayment.logger("===== finish checking transaction =====");
    if (check.status == 0) {
      assert(check.status == 0);
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess.call(_transaction);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ABACheckoutSuccess()));
      }
    } else {
      if (widget.onPaymentFail != null) {
        widget.onPaymentFail.call(_transaction);
      } else {
        if (check.status == 6) {
          Fluttertoast.showToast(msg: "please try again");
        } else {
          await Fluttertoast.showToast(msg: check.description);
        }
      }
    }
  }
}
