import 'dart:async';
import 'package:app_transaksi_barang/model/model_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:app_transaksi_barang/db/db_helper.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper();

  final StreamController<List<TransactionWithItems>> _transactionsController =
  StreamController<List<TransactionWithItems>>.broadcast();

  Stream<List<TransactionWithItems>> get transactionsStream =>
  _transactionsController.stream;

  Future<List<TransactionWithItems>> searchTransactions(String query) async {
    final transactions = await dbHelper.searchTransactions(query);
    _transactionsController.add(transactions);
    return transactions;
  }

  Future<void> insertTransaction(
    BuildContext context,
    TextEditingController nomorController,TextEditingController tanggalController,TextEditingController kodeController,TextEditingController namaController,TextEditingController noTeleponController, 
    TextEditingController kodebarangController, TextEditingController nobarangController, TextEditingController hargaController, TextEditingController jumlahController, TextEditingController totalController,
    ) async {
    try {
      String number = nomorController.text;
      String date = tanggalController.text;
      String code = kodeController.text;
      String name = namaController.text;
      String phone = noTeleponController.text;
      Map<String, dynamic> transactionData = {
        'number': number,
        'date': date,
        'code': code,
        'name': name,
        'phone': phone,
      };
      await dbHelper.initializeDatabase();
      final int transactionId = await dbHelper.insertTransaction(transactionData);

      // ignore: use_build_context_synchronously
      await insertItem(kodebarangController, nobarangController, hargaController, jumlahController, totalController, transactionId);
      await _updateTransactionsStream();
      print(transactionId);
    } catch (error) {
      print("Error updating transaction: $error");
      throw error;
    }
  }

  Future<void> updateTransaction(
    TextEditingController nomorController,
    TextEditingController tanggalController,
    TextEditingController kodeController,
    TextEditingController namaController,
    TextEditingController noTeleponController,
    int transactionId,
  ) async {
    try {
      String number = nomorController.text;
      String date = tanggalController.text;
      String code = kodeController.text;
      String name = namaController.text;
      String phone = noTeleponController.text;

      Transaction transactionData = Transaction(
        id: transactionId,
        number: number,
        date: date,
        code: code,
        name: name,
        phone: phone,
      );
      await dbHelper.initializeDatabase();
      await dbHelper.updateTransaction(transactionData.toMap());
      await _updateTransactionsStream();
    } catch (error) {
      print("Error updating transaction: $error");
      throw error;
    }
  }

  Future<void> deleteTransaction(int id) async {
    await dbHelper.deleteTransaction(id);
    await _updateTransactionsStream();
  }

  Future<void> _updateTransactionsStream() async {
    final transactions =
        await dbHelper.getAllTransactionsWithItems().toList();
    _transactionsController.add(transactions.cast<TransactionWithItems>());
  }


  Future<List<Map<String, dynamic>>> getItemsForTransaction(
      int transactionId) async {
    return await dbHelper.getItemsForTransaction(transactionId);
  }

  Future<void> insertItem(
      TextEditingController kodebarangController,
      TextEditingController nomorbarangController,
      TextEditingController hargaController,
      TextEditingController jumlahController,
      TextEditingController totalController,
      int transactionId,
    ) async {
      try {
        String kodebarang = kodebarangController.text;
        String nomorbarang = nomorbarangController.text;
        String harga = hargaController.text;
        String jumlah = jumlahController.text;
        String total = totalController.text;
        Map<String, dynamic> itemData = {
          'id': transactionId,
          'transaction_id': transactionId,
          'item_code': kodebarang,
          'item_number': nomorbarang,
          'price': harga,
          'quantity': jumlah,
          'total': total,
        };

        await dbHelper.initializeDatabase();
        await dbHelper.insertItem(itemData,);
        await _updateTransactionsStream();
        // ignore: use_build_context_synchronously
      } catch (error) {
        print("Error updating transaction: $error");
        throw error;
      }
  }
  

  Future<void> updateItem(
      TextEditingController kodebarangController,
      TextEditingController nomorbarangController,
      TextEditingController hargaController,
      TextEditingController jumlahController,
      TextEditingController totalController,
      int transactionId,
  ) async {
      try {
        String kodebarang = kodebarangController.text;
        String nomorbarang = nomorbarangController.text;
        String harga = hargaController.text;
        String jumlah = jumlahController.text;
        String total = totalController.text;

        Map<String, dynamic> itemData = {
          'id': transactionId,
          'transaction_id': transactionId,
          'item_code': kodebarang,
          'item_number': nomorbarang,
          'price': harga,
          'quantity': jumlah,
          'total': total,
        };

        await dbHelper.initializeDatabase();
        await dbHelper.updateItem(itemData);
        await _updateTransactionsStream();
      } catch (error) {
        print("Error updating transaction: $error");
        throw error;
    }
  }

  Future<void> deleteItem(int id) async {
    await dbHelper.deleteItem(id);
    await _updateTransactionsStream();
  }

  @override
  void dispose() {
    super.dispose();
    _transactionsController.close();
  }
}
