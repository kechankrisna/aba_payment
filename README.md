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

### Available methods:
- `onBeginCheckout(ABATransaction transaction)`: Triggered when user pressed checkout button.
- `onFinishCheckout(ABATransaction transaction)`: Triggered when after user pressed checkout button and transaction is created successfully.
- `onBeginCheckTransaction(ABATransaction transaction)`: Triggered when user completed transaction payment and current transaction will be started to check if it success or failed.
- `onFinishCheckTransaction(ABATransaction transaction)`: Triggered when user completed transaction payment and current transaction checking event is finished.
- `onCreatedTransaction(int value, String msg)`: Triggered when user completed transaction payment and current transaction checking event is finished.
- `onPaymentSuccess(ABATransaction transaction)`: Triggered when payment transaction was completed successfully. User can route to another screen after successfully. By default navigated to ABACheckoutSuccess()
- `onPaymentFail(ABATransaction transaction)`: Triggered when payment transaction was uncompleted. User can show any message.

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


## Configuration on Server Side
- [PHP](readme/README.md): This file will tell you each step to config your php code on server side