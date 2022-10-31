import 'package:aba_payment/model/aba_mechant.dart';
import 'package:aba_payment/service/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ABACheckoutWebView extends StatefulWidget {
  final ABAMerchant merchant;
  final Uri? uri;

  const ABACheckoutWebView({Key? key, this.uri, required this.merchant})
      : super(key: key);
  @override
  _ABACheckoutWebViewState createState() => _ABACheckoutWebViewState();
}

class _ABACheckoutWebViewState extends State<ABACheckoutWebView> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webViewController;

  PullToRefreshController? pullToRefreshController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.checkoutLabel.toUpperCase()),
        centerTitle: true,
      ),
      body: InAppWebView(
        pullToRefreshController: pullToRefreshController,
        initialSettings: InAppWebViewSettings(
          cacheEnabled: true,
          useHybridComposition: true,
          thirdPartyCookiesEnabled: true,
          sharedCookiesEnabled: true
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
          webViewController.loadUrl(
            urlRequest: URLRequest(url: WebUri.uri(widget.uri!), headers: {
              "Referer": widget.merchant.refererDomain!,
            }),
          );
        },
      ),
    );
  }
}
