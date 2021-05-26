# aba_payment

This package will allow developer integrate their flutter app with aba payway easily. This plugin use WebView for embeding web content checkout and url_launcher to open schema for both ios and android.

## Support :
- &check; Android Minimum SDK Version: 21
- &check; IOS minimum target Version: 12

## Payment Option:
- &check; Credit/Debit Card ([flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview))
- &check; ABA Payway Mobile ([url_launcher](https://pub.dev/packages/url_launcher))

## Classes:
- [ABAClientHelper](lib/service/aba_client_helper.dart): Handle http request for creating any transaction
- [ABATransaction](lib/model/aba_transaction.dart): to instantiate any transaction object
- [ABAServerResponse](lib/model/aba_transaction.dart): represent response object for every creating transaction process
- [ABAMerchant](lib/model/aba_merchant.dart): represent merchant object

## Widgets:
- [ABACheckoutContainer()](lib/ui/aba_checkout_container.dart):A completed widget which allow user intergrate ABA Payment into their flutter app easily

## Example:
```
ABACheckoutContainer(
    amount: _total,
    shipping: _shipping,
    firstname: _firstname,
    lastname: _lastname,
    email: _email,
    phone: _phone,
    items: [..._items.map((e) => e.toMap()).toList()],
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
    // onPaymentSuccess: (transaction) {
    //   print("onPaymentSuccess ${transaction.toMap()}");
    // },
)
```
- [Completed Cart Screen](example/lib/screens/cart_screen.dart): This file will demonstrate you how to intergrate your flutter app with payway mobile