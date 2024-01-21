import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionWithItems {
  final Map<String, dynamic> transactionData;
  final List<Map<String, dynamic>> itemsData;

  TransactionWithItems({required this.transactionData, required this.itemsData});
}

class DatabaseHelper {
  late Database _database;
  final StreamController<List<TransactionWithItems>> _transactionsController =
      StreamController<List<TransactionWithItems>>.broadcast();

  Stream<List<TransactionWithItems>> get transactionsStream =>
      _transactionsController.stream;

  DatabaseHelper() {
    initializeDatabase();
  }
  
  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'transaction_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT, isLoggedIn INTEGER DEFAULT 1)',
        );
        await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, number TEXT, date TEXT, created TEXT,'
          ' code TEXT, name TEXT, phone TEXT)',
        );
        await db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, transaction_id INTEGER,'
          ' item_code TEXT, item_number TEXT, price REAL, quantity INTEGER, total REAL,'
          ' FOREIGN KEY(transaction_id) REFERENCES transactions(id))',
        );
      },
      version: 2,
    );
  }

  Future<List<TransactionWithItems>> searchTransactions(String query) async {
    final Database db = _database;

    final List<Map<String, dynamic>> searchData = await db.rawQuery(
      'SELECT * FROM transactions WHERE number LIKE ? OR date LIKE ? OR code LIKE ? OR name LIKE ? OR phone LIKE ?',
      ['%$query%', '%$query%', '%$query%', '%$query%', '%$query%'],
    );

    final List<TransactionWithItems> transactionsWithItems = [];

    for (var transactionData in searchData) {
      final List<Map<String, dynamic>> itemsData =
          await getItemsForTransaction(transactionData['id']);
      transactionsWithItems.add(TransactionWithItems(
        transactionData: transactionData,
        itemsData: itemsData,
      ));
    }

    return transactionsWithItems;
  }

  Future<Map<String, dynamic>> getTransactionDataById(int transactionId) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [transactionId],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return {};
  }

  Future<Map<String, dynamic>> getItemDataById(int itemId) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'items',
      where: 'id = ?',
      whereArgs: [itemId],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return {};
  }

  

  Future<void> insertUser(String email, String password) async {
    await _database.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<Map<String, dynamic>> getUserProfile(String userEmail) async {
    final Database db = await _database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [userEmail],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {'email': userEmail, 'name': 'Guest'};
    }
  }

  Future<void> updatePassword(String email, String newPassword) async {
    await _database.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> logout() async {
    await _database.transaction((txn) async {
      await txn.rawUpdate('UPDATE users SET isLoggedIn = 0');
    });
  }

  Future<void> deleteusers() async {
    await _database.delete('users');
  }
  

  Stream<List<TransactionWithItems>> getAllTransactionsWithItems() async* {
    await for (var _ in Stream.periodic(const Duration(seconds: 1))) {
      final List<Map<String, dynamic>> transactionsData = await _database.query('transactions');

      final List<TransactionWithItems> transactionsWithItems = [];

      for (var transactionData in transactionsData) {
        final List<Map<String, dynamic>> itemsData = await getItemsForTransaction(transactionData['id']);
        transactionsWithItems.add(TransactionWithItems(
          transactionData: transactionData,
          itemsData: itemsData,
        ));
      }

      yield transactionsWithItems;
    }
  }


  Future<void> _updateTransactionsStream() async {
  final transactions =
      await getAllTransactionsWithItems().first; // Use .first to get the latest data.
  _transactionsController.add(transactions);
  }


  Future<int> insertTransaction(Map<String, dynamic> transactionData) async {
    int transactionId = await _database.insert('transactions', transactionData);
    await _updateTransactionsStream();
    return transactionId;
  }

  Future<void> updateTransaction(Map<String, dynamic> transactionData) async {
    await _database.update(
      'transactions',
      transactionData,
      where: 'id = ?',
      whereArgs: [transactionData['id']],
    );
    await _updateTransactionsStream();
  }

  Future<void> deleteTransaction(int id) async {
    await _database.delete('transactions', where: 'id = ?', whereArgs: [id]);
    await _updateTransactionsStream();
  }

  Future<void> insertItem(Map<String, dynamic> itemData) async {
    await _database.insert(
      'items',
      itemData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _updateTransactionsStream();
  }

  Future<void> updateItem(Map<String, dynamic> itemData) async {
    await _database.update(
      'items',
      itemData,
      where: 'id = ?',
      whereArgs: [itemData['id']],
    );
    await _updateTransactionsStream();
  }
 

  Future<void> deleteItem(int id) async {
    await _database.delete('items', where: 'id = ?', whereArgs: [id]);
    await _updateTransactionsStream();
  }

  Future<List<Map<String, Object?>>> getItemsForTransaction(int transactionId) async {
    return await _database.query('items', where: 'transaction_id = ?', whereArgs: [transactionId]);
  }

  Future<void> close() async {
    await _transactionsController.close();
  }
}