import 'dart:io' as io;
import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/model.dart';
import 'package:aba_payment/services/strings.dart';
import 'package:aba_payment/ui/aba_checkout_success.dart';
import 'package:aba_payment/ui/aba_checkout_webview.dart';
import 'package:flutter/material.dart';
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
  /// `amount` respresent total amount to checkout
  final double amount;

  /// `shipping` respresent shipping cost
  final double shipping;

  /// `firstname` respresent user firstname
  final String firstname;

  /// `lastname` respresent user lastname
  final String lastname;

  /// `email` respresent user email
  final String email;

  /// `phone` respresent user valid phone number
  final String phone;

  /// `items` respresent list of items(json format) that user selected
  final List<ABATransactionItem> items;

  /// `checkoutApiUrl` respresent checkout api link from the server side
  final String checkoutApiUrl;

  /// `merchant` respesent ABAMerchant object
  final ABAMerchant merchant;

  /// `enabled` allow button to be pressed
  final bool enabled;

  /// `checkoutLabel` allow user to change button text
  final Widget? checkoutLabel;

  /// ### METHOD: `onBeginCheckout(ABATransaction transaction)`
  /// `Triggered when user pressed checkout button`
  final Function(ABATransaction? transaction)? onBeginCheckout;

  /// ### METHOD: `onFinishCheckout(ABATransaction transaction)`
  /// `Triggered when after user pressed checkout button and transaction is created successfully`
  final Function(ABATransaction? transaction)? onFinishCheckout;

  /// ### METHOD: `onBeginCheckTransaction(ABATransaction transaction)`
  /// `Triggered when user completed transaction payment and current transaction will be started to check if it success or failed`
  final Function(ABATransaction? transaction)? onBeginCheckTransaction;

  /// ### METHOD: `onFinishCheckTransaction(ABATransaction transaction)`
  /// `Triggered when user completed transaction payment and current transaction checking event is finished`
  final Function(ABATransaction? transaction)? onFinishCheckTransaction;

  final Function(int? value, String? msg)? onCreatedTransaction;

  /// ### METHOD: `onPaymentSuccess(ABATransaction transaction)`
  /// `Triggered when payment transaction was completed successfully`
  /// `User can route to another screen after successfully`
  /// #### `Default:` navigator to ABACheckoutSuccess()
  final Function(ABATransaction? transaction)? onPaymentSuccess;

  /// ### METHOD: `onPaymentFail(ABATransaction transaction)`
  /// `Triggered when payment transaction was uncompleted`
  /// `User can show any message`
  /// #### `Default:` toast bar will be showed to describe the problem
  final Function(ABATransaction? transaction)? onPaymentFail;

  const ABACheckoutContainer({
    Key? key,
    required this.amount,
    required this.shipping,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.phone,
    this.items = const [],
    required this.checkoutApiUrl,
    required this.merchant,
    this.enabled = false,
    this.checkoutLabel,
    this.onBeginCheckout,
    this.onFinishCheckout,
    this.onBeginCheckTransaction,
    this.onFinishCheckTransaction,
    this.onCreatedTransaction,
    this.onPaymentSuccess,
    this.onPaymentFail,
  })  : assert(amount > 0),
        // assert(lastname != null),
        // assert(firstname != null),
        // assert(email != null),
        // assert(phone != null),
        // assert(checkoutApiUrl != null),
        // assert(merchant != null),
        super(key: key);
  @override
  _ABACheckoutContainerState createState() => _ABACheckoutContainerState();
}

class _ABACheckoutContainerState extends State<ABACheckoutContainer>
    with WidgetsBindingObserver {
  bool _requiredCheck = false;
  ABATransaction? _transaction;
  String? _error;

  @override
  void initState() {
    _transaction = ABATransaction.instance(widget.merchant);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
            value: _transaction!.option,
            onChanged: (v) => setState(() => _transaction!.option = v!),
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
                child: widget.checkoutLabel ??
                    Text(
                      Strings.checkoutLabel,
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
        _transaction!.amount = widget.amount;
        _transaction!.firstname = widget.firstname;
        _transaction!.lastname = widget.lastname;
        _transaction!.email = widget.email;
        _transaction!.phone = widget.phone;
        _transaction!.shipping = widget.shipping;
        _transaction!.items = widget.items;
      });
    }
  }

  /// ## `onCheckOut`
  /// This event will be triggered whenever user pressed checkout button
  _onBeginCheckout() async {
    _updateTransaction();
    widget.onBeginCheckout?.call(_transaction);

    if (_transaction!.option == ABAPaymentOption.abapay_deeplink) {
      var createResult = await _transaction!.create();

      widget.onFinishCheckout?.call(_transaction);
      ABAPayment.logger(createResult.toMap());
      if (createResult.status == null) {
        return;
      }
      if (createResult.status == 0) {
        widget.onCreatedTransaction
            ?.call(createResult.status, createResult.description);

        /// [open native using deeplink]
        if (createResult.abapayDeeplink != null) {
          if (await canLaunchUrl(Uri.parse(createResult.abapayDeeplink!))) {
            setState(() => _requiredCheck = true);
            await canLaunchUrl(Uri.parse(createResult.abapayDeeplink!));
          } else {
            if (io.Platform.isIOS) {
              await canLaunchUrl(Uri.parse(createResult.appStore!));
            } else if (io.Platform.isAndroid) {
              await canLaunchUrl(Uri.parse(createResult.playStore!));
            }
          }
        } else {
          Fluttertoast.showToast(msg: "error deeplink");
        }
      } else {
        Fluttertoast.showToast(msg: "${createResult.description}ff");
      }
    } else if (_transaction!.option == ABAPaymentOption.cards ||
        _transaction!.option == ABAPaymentOption.abapay) {
      var map = _transaction!.toMap();
      var parsed = Uri.tryParse(widget.checkoutApiUrl)!;
      Uri uri;

      /// `check if domain name contain https`
      if (parsed.authority.contains("https")) {
        uri = Uri.https(parsed.authority, parsed.path, map);
      } else {
        uri = Uri.http(parsed.authority, parsed.path, map);
      }
      ABAPayment.logger.info(uri);
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
    var checkResult = await _transaction!.check();
    setState(() => _requiredCheck = false);
    widget.onFinishCheckTransaction?.call(_transaction);
    ABAPayment.logger("===== finish checking transaction =====");
    if (checkResult.status == 0) {
      ABAPayment.logger.error("checkResult.status");
      assert(checkResult.status == 0);
      if (widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!.call(_transaction);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ABACheckoutSuccess()));
      }
    } else {
      if (widget.onPaymentFail != null) {
        widget.onPaymentFail!.call(_transaction);
      } else {
        if (checkResult.status == 6) {
          Fluttertoast.showToast(msg: "please try again");
        } else {
          await Fluttertoast.showToast(msg: checkResult.description!);
        }
      }
    }
  }
}
