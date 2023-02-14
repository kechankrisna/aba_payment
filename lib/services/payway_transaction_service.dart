import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:aba_payment/model.dart';
import 'package:aba_payment/services/services.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../model/payway_create_transaction.dart';
import 'payway_client_response_service.dart';

class PaywayTransactionService {
  static PaywayTransactionService? instance;

  PaywayTransactionService._();

  static void ensureInitialized(ABAMerchant merchant) {
    PaywayTransactionService.instance ??= PaywayTransactionService._();
    PaywayTransactionService.instance!.initialize(merchant);
  }

  void initialize(ABAMerchant merchant) {
    assert(PaywayTransactionService.instance != null);
    if (PaywayTransactionService.instance == null) {
      throw Exception(
          'Make sure run PaywayTransactionService.ensureInitialized()');
    }
    instance!.merchant = merchant;
  }

  ABAMerchant? merchant;

  ABAClientService? get helper {
    if (merchant == null) return null;
    return ABAClientService(merchant);
  }

  String uniqueTranID() => "${DateTime.now().microsecondsSinceEpoch}";
  String uniqueReqTime() => "${DateFormat("yMddHms").format(DateTime.now())}";

  /// ## [createPurchase]
  /// create a new trasaction
  Future<PaywayCreateTransactionResponse> createPurchase(
      {required PaywayCreateTransaction transaction}) async {
    var res = PaywayCreateTransactionResponse(status: 11);
    Map<String, dynamic> map = transaction.toFormDataMap();
    var formData = FormData.fromMap(map);
    try {
      if (helper == null) return PaywayCreateTransactionResponse();
      final client = helper!.client;
      client.interceptors.add(dioLoggerInterceptor);
      Response<String> response =
          await client.post("/purchass", data: formData);

      var map = json.decode(response.data!) as Map<String, dynamic>;
      res = PaywayCreateTransactionResponse.fromMap(map);
      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      res.description = ABAClientService.handleResponseError(error);
    }
    return res;
  }

  /// /// ## [check]
  /// /// check the current status of this transaction vai its id
  /// Future<ABAServerResponse> check(
  ///     {required String tranID, required String reqTime}) async {
  ///   var res = ABAServerResponse(status: 11);

  ///   var hash = this.getHash(reqTime: reqTime, tranID: tranID);
  ///   var form = FormData.fromMap({
  ///     "req_time": reqTime,
  ///     "tran_id": tranID,
  ///     "hash": hash,
  ///     "merchant_id": this.merchant!.merchantID,
  ///   });
  ///   var helper = ABAClientService(merchant);
  ///   ABAPayment.logger.error("tid $tranID");
  ///   try {
  ///     Response<String> response =
  ///         await helper.client.post("/check-transaction", data: form);
  ///     var map = json.decode(response.data!) as Map<String, dynamic>;
  ///     ABAPayment.logger.error("checkMap $map $response");
  ///     res = ABAServerResponse.fromMap(map);
  ///     return res;
  ///   } catch (error, stacktrace) {
  ///     print("Exception occured: $error stackTrace: $stacktrace");
  ///     res.description = ABAClientService.handleResponseError(error);
  ///   }
  ///   return ABAServerResponse();
  /// }

  /// /// ## [isValidate]
  /// /// will return true if transaction completed
  /// /// otherwise false
  /// Future<bool> isValidate(
  ///     {required String tranID, required String reqTime}) async {
  ///   var result = await check(tranID: tranID, reqTime: reqTime);
  ///   return (result.status == 0);
  /// }
}
