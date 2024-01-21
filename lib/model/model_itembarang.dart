class ItemBarang {
  final int id;
  final int transactionId;
  final String itemCode;
  final String itemNumber;
  final double price;
  final int quantity;
  final double total;

  ItemBarang({
    required this.id,
    required this.transactionId,
    required this.itemCode,
    required this.itemNumber,
    required this.price,
    required this.quantity,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'itemCode': itemCode,
      'itemNumber': itemNumber,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  factory ItemBarang.fromMap(Map<String, dynamic> map) {
    return ItemBarang(
      id: map['id'],
      transactionId: map['transactionId'],
      itemCode: map['itemCode'],
      itemNumber: map['itemNumber'],
      price: map['price'],
      quantity: map['quantity'],
      total: map['total'],
    );
  }
}
