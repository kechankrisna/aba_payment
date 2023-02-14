import 'dart:convert';

import 'package:aba_payment/enumeration.dart';
import 'package:aba_payment/extension.dart';
import 'package:aba_payment/model/aba_mechant.dart';
import 'package:aba_payment/model/aba_payment.dart';
import 'package:aba_payment/model/aba_transacition_item.dart';
import 'package:aba_payment/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'aba_server_response.dart';

class ABATransaction {
  late ABAMerchant? merchant;
  late String tranID;
  late String reqTime;
  late double? amount;
  List<ABATransactionItem>? items;
  String? hash;
  String? firstname;
  String? lastname;
  String? phone;
  String? email;
  String? returnUrl;
  String? continueSuccessUrl;
  String? returnParams;
  String? phoneCountryCode;
  String? preAuth;
  ABAPaymentOption? option;
  double? shipping;

  ABATransaction({
    this.merchant,
    required this.tranID,
    required this.reqTime,
    this.amount,
    this.items,
    this.hash,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.returnUrl,
    this.continueSuccessUrl,
    this.returnParams,
    this.phoneCountryCode,
    this.preAuth,
    this.option,
    this.shipping,
  });

  factory ABATransaction.instance(ABAMerchant merchant) {
    // var format = DateFormat("yMddHms").format(DateTime.now()); //2021 01 23 234559 OR 2021 11 07 132947
    final now = DateTime.now();
    return ABATransaction(
      merchant: merchant,
      tranID: "${now.microsecondsSinceEpoch}",
      reqTime: "${DateFormat("yMddHms").format(now)}",
      amount: 0.00,
      items: [],
      firstname: "",
      lastname: "",
      phone: "",
      email: "",
      option: ABAPaymentOption.abapay_deeplink,
      shipping: 0.00,
    );
  }

  /// ### [ABATransaction.fromMap]
  factory ABATransaction.fromMap(Map<String, dynamic> map) {
    return ABATransaction(
      merchant: ABAMerchant.fromMap(map),
      tranID: map["tran_id"],
      reqTime: map["req_time"],
      amount: double.tryParse("${map["amount"]}"),
      items: List.from(map['items'] ?? [])
          .map((e) => ABATransactionItem.fromMap(e))
          .toList(),
      hash: map["hash"],
      firstname: map["firstname"],
      lastname: map["lastname"],
      phone: map["phone"],
      email: map["email"],
      returnUrl: map["return_url"],
      continueSuccessUrl: map["continue_success_url"],
      returnParams: map["return_params"],
      phoneCountryCode: map["phone_country_code"],
      preAuth: "PreAuth",
      option: map["payment_option"].toString().toAcceptPaymentOption,
      shipping: map["shipping"] ?? "" as double?,
    );
  }

  double get totalPrice {
    double result = 0;
    this
        .items!
        .fold(result, (dynamic pre, e) => result += e.price! * e.quantity!);
    return result;
  }

  String get encodedReturnUrl => EncoderService.base46_encode(returnUrl);

  String get encodedItem =>
      EncoderService.base46_encode(items!.map((e) => e.toMap()).toList());

  /// ### [toMap]
  /// [return] map object
  Map<String, dynamic> toMap() {
    var _currency = "USD";
    var _type = "purchase";
    String _hash = ABAClientService(merchant).getHash(
      reqTime: reqTime,
      tranID: tranID,
      amount: "$amount",
      items: encodedItem,
      shipping: "$shipping",
      firstName: firstname,
      lastName: lastname,
      email: email,
      phone: phone,
      type: _type,
      paymentOption: option!.toText,
      currency: _currency,
      returnUrl: encodedReturnUrl,
    );
    var map = {
      "req_time": reqTime,
      "tran_id": tranID,
      "amount": "$amount",
      "items": "$encodedItem",
      "hash": "$_hash",
      "firstname": "$firstname",
      "lastname": "$lastname",
      "phone": "$phone",
      "email": "$email",
      "return_url": encodedReturnUrl,
      "continue_success_url": continueSuccessUrl ?? "",
      "return_params": returnParams ?? "",
      // "return_params": {"tran_id": tranID, "status": 0},
      // "phone_country_code": phoneCountryCode ?? "855",
      // "PreAuth": preAuth,
      "payment_option": "${option!.toText}",
      "shipping": "$shipping",
      "currency": "$_currency",
      "merchant_id": "${merchant!.merchantID}",
      "type": _type,
    };
    return map;
  }

  /// ## [create]
  /// create a new trasaction
  Future<ABAServerResponse> create() async {
    var res = ABAServerResponse(status: 11);
    Map<String, dynamic> map = this.toMap();
    map["type"] = "purchase";
    var formData = FormData.fromMap(map);
    try {
      var helper = ABAClientService(merchant);
      var dio = helper.client;
      debugPrint(json.encode(map));
      dio.interceptors.add(dioLoggerInterceptor);
      Response<String> response = await dio.post("/purchase", data: formData);
      // ABAPayment.logger.debug(response);
      var cast = json.decode(response.data!) as Map<String, dynamic>;
      res = ABAServerResponse.fromMap(cast);
      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      res.description = ABAClientService.handleResponseError(error);
    }
    return ABAServerResponse();
  }

  /// ## [check]
  /// check the current status of this transaction vai its id
  Future<ABAServerResponse> check() async {
    var res = ABAServerResponse(status: 11);
    final _reqTime = reqTime;
    var hash =
        ABAClientService(merchant).getHash(reqTime: _reqTime, tranID: tranID!);
    var form = FormData.fromMap({
      "req_time": _reqTime,
      "tran_id": tranID,
      "hash": hash,
      "merchant_id": this.merchant!.merchantID,
    });
    var helper = ABAClientService(merchant);
    ABAPayment.logger.error("tid $tranID");
    try {
      Response<String> response =
          await helper.client.post("/check-transaction", data: form);
      var map = json.decode(response.data!) as Map<String, dynamic>;
      ABAPayment.logger.error("checkMap $map $response");
      res = ABAServerResponse.fromMap(map);
      return res;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      res.description = ABAClientService.handleResponseError(error);
    }
    return ABAServerResponse();
  }

  /// ## [validate]
  /// will return true if transaction completed
  /// otherwise false
  Future<bool> validate() async {
    var result = await this.check();
    return (result.status == 0);
  }
}
