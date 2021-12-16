class ItemModel {
  String? name;
  double? price;
  double? quantity;

  ItemModel({
    this.name,
    this.price,
    this.quantity,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    assert(map["name"] != null);
    assert(map["price"] != null);
    assert(map["quantity"] != null);
    return ItemModel(
      name: map["name"],
      price: double.tryParse("${map["price"]}") ?? 0.0,
      quantity: double.tryParse("${map["quantity"]}") ?? 0.0,
    );
  }

  /// [toMap] will be so useful to complete payment
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
    };
  }
}
