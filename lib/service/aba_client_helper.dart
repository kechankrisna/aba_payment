import 'dart:convert';
import 'package:aba_payment/model/aba_payment.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:aba_payment/model/aba_mechant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ABAClientHelper {
  final ABAMerchant merchant;
  ABAClientHelper(this.merchant);

  /// [getDio]
  /// Return dio object for http helper
  /// ### Example:
  /// ```
  /// var merchant = ABAMerchant();
  /// var helper = ABAClientHelper(merchant);
  /// var dio = helper.getDio();
  /// ```
  Dio getDio() {
    Dio dio = Dio();
    dio.options.baseUrl =
        "${merchant.baseApiUrl}/api/payment-gateway/v1/payments/purchase";
    dio.options.connectTimeout = 60 * 1000; //60 seconds
    dio.options.receiveTimeout = 60 * 1000; //60 seconds

    /// [add interceptors]
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers["Referer"] = merchant.refererDomain;
      // options.headers["Accept"] = "application/json";
      return handler.next(options);
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      return handler.next(e); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    }));
    return dio;
  }

  /// [getHash]
  ///
  /// `tranID`: unique tran_id < 20 characters (number, character and (-) only)
  ///
  /// `amount`: total amount
  ///
  /// `item`: base64_encode (json_encode(array item))
  ///
  /// `shipping`: shipping value
  ///
  /// ### Example:
  /// ```
  /// var merchant = ABAMerchant();
  /// var helper = ABAClientHelper(merchant);
  /// var tranID = DateTime.now().microsecondsSinceEpoch.toString();
  /// var reqTime = DateTime.now().toUtc();
  /// var amount = 0.00;
  /// var hash = helper.getHash(tranID: tranID, amount: amount);
  /// print(hash);
  /// ```

  String getHash({
    @required String reqTime,
    @required String tranID,
    String amount = "",
    String items = "",
    String shipping = "",
    String ctid = "",
    String pwt = "",
    String firstName = "",
    String lastName = "",
    String email = "",
    String phone = "",
    String type = "",
    String paymentOption = "",
    String returnUrl = "",
    String cancelUrl = "",
    String continueSuccessUrl = "",
    String returnDeeplink = "",
    String currency = "USD",
    String customFields = "",
    String returnParams = "",
  }) {
    // String =
    // req_time + merchant_id +
    // tran_id + amount + items +
    // shipping + ctid + pwt +
    // firstname + lastname +
    // email + phone + type +
    // payment_option + return_url +
    // cancel_url + continue_success_url +
    // return_deeplink + currency + custom_fields + return_params with public_key.
    assert(tranID != null);
    // assert(amount != null);
    var key = utf8.encode(merchant.merchantApiKey);
    var raw =
        "$reqTime ${merchant.merchantID} $tranID $amount $items $shipping $ctid $pwt $firstName $lastName $email $phone $type $paymentOption $returnUrl $cancelUrl $continueSuccessUrl $returnDeeplink $currency $customFields $returnParams";
    var str =
        "$reqTime${merchant.merchantID}$tranID$amount$items$shipping$ctid$pwt$firstName$lastName$email$phone$type$paymentOption$returnUrl$cancelUrl$continueSuccessUrl$returnDeeplink$currency$customFields$returnParams";
    ABAPayment.logger.warning("raw $raw");
    ABAPayment.logger.warning("str $str");
    var bytes = utf8.encode(str);
    var digest = crypto.Hmac(crypto.sha512, key).convert(bytes);
    var hash = base64Encode(digest.bytes);
    return hash;
  }

  /// [handleTransactionResponse]
  ///
  /// `This will be describe response from each transaction based on status code`
  String handleTransactionResponse(int status) {
    switch (status) {
      case 0:
        return "success";
        break;
      case 1:
        return "invalid hash";
        break;
      case 2:
        return "invalid hash";
        break;
      case 3:
        return "invalid amount";
        break;
      case 4:
        return "duplicate tran_id";
        break;
      default:
        return "other - server-side error";
    }
  }

  static String handleResponseError(dynamic error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          errorDescription =
              "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.other:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
