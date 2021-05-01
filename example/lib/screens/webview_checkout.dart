import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewCheckoutScreen extends StatefulWidget {
  final String value;

  const WebViewCheckoutScreen({Key key, this.value}) : super(key: key);
  @override
  _WebViewCheckoutScreenState createState() => _WebViewCheckoutScreenState();
}

class _WebViewCheckoutScreenState extends State<WebViewCheckoutScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      // clearCache: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
      javaScriptCanOpenWindowsAutomatically: true,
      javaScriptEnabled: true,
      verticalScrollBarEnabled: true,
      useShouldInterceptAjaxRequest: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      cacheEnabled: true,
      useShouldInterceptFetchRequest: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      thirdPartyCookiesEnabled: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsPictureInPictureMediaPlayback: true,
      enableViewportScale: true,
      suppressesIncrementalRendering: true,
      sharedCookiesEnabled: true,
    ),
  );
  PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        webViewController.loadUrl(
          urlRequest: URLRequest(
            url: Uri.file(widget.value),
            headers: {
              "Referer": "https://mylekha.app",
              "referer": "https://mylekha.app",
            },
            method: "GET",
            iosCachePolicy: IOSURLRequestCachePolicy
                .RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,
          ),
        );
        webViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CHECK OUT"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: InAppWebView(
          pullToRefreshController: pullToRefreshController,
          initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
            webViewController.loadUrl(
              urlRequest: URLRequest(
                url: Uri.file(widget.value),
                headers: {
                  "Referer": "https://mylekha.app",
                  "referer": "https://mylekha.app",
                },
                method: "GET",
              ),
            );
          },
        ),
      ),
      
    );
    
  }
}
