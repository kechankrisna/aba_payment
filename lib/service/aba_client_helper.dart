import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:aba_payment/model/aba_mechant.dart';
import 'package:dio/dio.dart';

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
        "${merchant.baseApiUrl}/api/${merchant.merchantApiName}";
    dio.options.connectTimeout = 60 * 1000; //60 seconds
    dio.options.receiveTimeout = 60 * 1000; //60 seconds

    /// [add interceptors]
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers["Referer"] = merchant.refererDomain;
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
  /// var amount = 0.00;
  /// var hash = helper.getHash(tranID: tranID, amount: amount);
  /// print(hash);
  /// ```
  String getHash({
    String tranID,
    double amount,
    String items: "",
    String shipping: "",
  }) {
    assert(tranID != null);
    // assert(amount != null);
    var key = utf8.encode(merchant.merchantApiKey);
    var bytes = utf8.encode(
        "${merchant.merchantID}$tranID${amount ?? ""}${items ?? ""}${shipping ?? ""}");
    var digest = crypto.Hmac(crypto.sha512, key).convert(bytes);
    var hash = base64Encode(digest.bytes);
    return hash;
  }

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

main() {
  // var merchant = ABAMerchant();
  // var helper = ABAClientHelper(merchant);
  // var dio = helper.getDio();
  // var tranID = DateTime.now().microsecondsSinceEpoch.toString();
  // var amount = 0.00;
  // var hash = helper.getHash(tranID: tranID, amount: amount);
  // print(hash);
  //
}
