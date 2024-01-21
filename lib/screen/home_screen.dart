import 'package:app_transaksi_barang/provider/user_provider.dart';
import 'package:app_transaksi_barang/widget/actions_button.dart';
import 'package:app_transaksi_barang/widget/card_transaction_.dart';
import 'package:flutter/material.dart';
import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:provider/provider.dart';
import '../widget/transaction_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.initializeDatabase(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF325E8C),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TransactionSearchDelegate(dbHelper),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF325E8C),
              ),
              child: Text(
                    'Menu Transakasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
              
            ),
            ListTile(
              title: const Text('List transaksi'),
              onTap: () {
                Navigator.pushNamed(context, '/home_page');
              },
            ),
            ListTile(
              title: const Text('List Barang'),
              onTap: () {
                Navigator.pushNamed(context, '/list_barang');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                Provider.of<UserProvider>(context, listen: false).logout().whenComplete(
                  () => Navigator.pushNamedAndRemoveUntil(context, '/login_page', (route) => false),
                );  
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<TransactionWithItems>>(
            stream: dbHelper.getAllTransactionsWithItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data transaksi.'));
              } else {
                List<TransactionWithItems> transactions = snapshot.data!;
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    // Membangun card untuk setiap transaksi
                    TransactionWithItems transaction = transactions[index];
                    List<Map<String, dynamic>> items = transaction.itemsData;
                    Map<String, dynamic>? itemData;
                    if (items.isNotEmpty) {
                      itemData = items.first;
                    }
                    // print(itemData!.length);
                    if (itemData != null) {
                    // Jika itemData tidak null, 
                      return Card_transaction(transaction: transaction, item: itemData);
                    } else {
                      // Jika itemData null,
                      return Card_transaction(transaction: transaction, item: null);
                    }
                  },
                );
              }
            },
        ),
      floatingActionButton: Actionsbutton(onPressed: () {  
        Navigator.pushNamed(context, '/transaksi');
      },),
    );
  }
}
