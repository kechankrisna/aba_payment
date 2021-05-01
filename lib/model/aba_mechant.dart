/// ## [ABAMerchant]
/// `Represent and Hold Merchant Credential provided by aba bank supporter`
/// ### [Example]
/// ```
///var merchant = ABAMerchant(
///   merchantID: "your_merchant_api",
///   merchantApiKey: "your_api_key",
///   merchantApiName: "your_merchant_name",
///   baseApiUrl: "based_api_url", // without merchantApiName
///   referedDomain: "", // whitelist domain
/// );
/// ```
class ABAMerchant {
  /// [internal]
  /// provided by api
  String _merchantID;
  String _merchantApiKey;
  String _merchantApiName;
  String _baseApiUrl;
  String _refererDomain;

  /// [getter]
  String get merchantID => _merchantID;
  String get merchantApiKey => _merchantApiKey;
  String get merchantApiName => _merchantApiName;
  String get baseApiUrl => _baseApiUrl;
  String get refererDomain => _refererDomain;

  ABAMerchant({
    String merchantID,
    String merchantApiKey,
    String merchantApiName,
    String baseApiUrl,
    String refererDomain,
  }) {
    assert(merchantID != null);
    assert(merchantApiKey != null);
    assert(merchantApiName != null);
    assert(baseApiUrl != null);
    assert(refererDomain != null);
    _merchantID = merchantID;
    _merchantApiKey = merchantApiKey;
    _merchantApiName = merchantApiName;
    _baseApiUrl = baseApiUrl;
    _refererDomain = refererDomain;
  }

  /// ### [ABAMerchant.fromMap]
  /// return ABAMerchant by converting from map object
  factory ABAMerchant.fromMap(Map<String, dynamic> map) {
    return ABAMerchant(
      merchantID: map["merchantID"],
      merchantApiKey: map["merchantApiKey"],
      merchantApiName: map["merchantApiName"],
      baseApiUrl: map["baseApiUrl"],
      refererDomain: map["refererDomain"],
    );
  }

  /// ### [toMap]
  /// return map of <string, string>
  Map<String, String> toMap() {
    return {
      "merchantID": merchantID,
      "merchantApiKey": merchantApiKey,
      "merchantApiName": merchantApiName,
      "baseApiUrl": baseApiUrl,
      "refererDomain": refererDomain
    };
  }
}
