class Transaction {
  final int id;
  final String number;
  final String date;
  final String code;
  final String name;
  final String phone;

  Transaction({
    required this.id,
    required this.number,
    required this.date,
    required this.code,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'date': date,
      'code': code,
      'name': name,
      'phone': phone,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      number: map['number'],
      date: map['date'],
      code: map['code'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}
