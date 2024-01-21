import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// ignore: camel_case_types
class Card_barang extends StatelessWidget {
  final TransactionWithItems transaction;
  final Map<String, dynamic>? item;
  const Card_barang({
    super.key, required this.transaction, required this.item,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          elevation: 2,
          margin: const EdgeInsets.all(16.0),
          color: Colors.white, 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item!['item_number'] ?? ''}',
                            style: const TextStyle(
                              color: Color(0xFF325E8C),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          const Row(
                            children: [
                              Text(
                                'Nama Barang',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Kode Barang',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                transaction.transactionData['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${item!['item_code'] ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const Row(
                            children: [
                              Text(
                                'Jumlah Barang',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 87.0),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0), 
                          Row(
                            children: [
                              Text(
                                '${item!['quantity']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 49.0),
                                child: Text(
                                  '${item!['total']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0,),
                const Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
                const SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/form_edit_barang', arguments: {
                          'transactionId': transaction.transactionData['id'],
                          'code': transaction.transactionData['code'],
                          'number': transaction.transactionData['number'],
                          'date': transaction.transactionData['date'],
                          'created': transaction.transactionData['created'],
                          'name': transaction.transactionData['name'],
                          'phone': transaction.transactionData['phone'],
                          'item': {
                            'transaction_id': item!['transaction_id'],
                            'item_code': item!['item_code'],
                            'item_number': item!['item_number'],
                            'price': item!['price'],
                            'quantity': item!['quantity'],
                            'total': item!['total'],
                          },
                        },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF325E8C),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Konfirmasi"),
                              content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: const Text("Tidak"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<TransactionProvider>(context, listen: false).deleteTransaction(transaction.transactionData['id']);
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: const Text("Ya"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF325E8C),
                        ),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), 
                        ),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF325E8C),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
  }
}