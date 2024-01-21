import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/widget/card_transaction_.dart';
import 'package:flutter/material.dart';

class TransactionSearchDelegate extends SearchDelegate<List<TransactionWithItems>> {
  final DatabaseHelper dbHelper;

  TransactionSearchDelegate(this.dbHelper);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, List<TransactionWithItems>.empty());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<TransactionWithItems>>(
      future: dbHelper.searchTransactions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak Ada Transaksi.'));
        } else {
          List<TransactionWithItems> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionWithItems transaction = transactions[index];
              List<Map<String, dynamic>> items = transaction.itemsData;
              Map<String, dynamic>? itemData;
              if (items.isNotEmpty) {
                itemData = items.first;
              }
              return Card_transaction(transaction: transaction, item: itemData);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}


