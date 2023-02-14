import 'dart:convert';
import 'package:aba_payment/model/payway_check_transaction.dart';
import 'package:aba_payment/model/payway_create_transaction.dart';
import 'package:aba_payment/model.dart';
import 'package:aba_payment/services/services.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'reponses/payway_check_transaction_response.dart';
import 'reponses/payway_create_transaction_response.dart';

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

  /// ## [createTransaction]
  /// create a new trasaction
  Future<PaywayCreateTransactionResponse> createTransaction(
      {required PaywayCreateTransaction transaction}) async {
    var res = PaywayCreateTransactionResponse(status: 11);
    Map<String, dynamic> map = transaction.toFormDataMap();
    var formData = FormData.fromMap(map);
    try {
      if (helper == null) return PaywayCreateTransactionResponse();
      final client = helper!.client;
      client.interceptors.add(dioLoggerInterceptor);
      Response<String> response =
          await client.post("/purchase", data: formData);

      var map = json.decode(response.data!) as Map<String, dynamic>;
      res = PaywayCreateTransactionResponse.fromMap(map);
      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      res.description = ABAClientService.handleResponseError(error);
    }
    return res;
  }

  /// ## [checkTransaction]
  /// check the current status of this transaction vai its id
  Future<PaywayCheckTransactionResponse> checkTransaction(
      {required PaywayCheckTransaction transaction}) async {
    var res = PaywayCheckTransactionResponse(status: 11);
    Map<String, dynamic> map = transaction.toFormDataMap();
    var formData = FormData.fromMap(map);

    try {
      if (helper == null) return PaywayCheckTransactionResponse();
      final client = helper!.client;
      client.interceptors.add(dioLoggerInterceptor);
      Response<String> response =
          await client.post("/check-transaction", data: formData);

      var map = json.decode(response.data!) as Map<String, dynamic>;
      res = PaywayCheckTransactionResponse.fromMap(map);
      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      res.description = ABAClientService.handleResponseError(error);
    }
    return res;
  }

  /// ## [isValidate]
  /// will return true if transaction completed
  /// otherwise false
  Future<bool> isTransactionCompleted(
      {required PaywayCheckTransaction transaction}) async {
    var result = await this.checkTransaction(transaction: transaction);
    return (result.status == 0);
  }
}
