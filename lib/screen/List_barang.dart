import 'package:app_transaksi_barang/provider/user_provider.dart';
import 'package:app_transaksi_barang/widget/actions_button.dart';
import 'package:app_transaksi_barang/widget/card_barang.dart';
import 'package:app_transaksi_barang/widget/itembarang_search_delegate.dart';
import 'package:app_transaksi_barang/widget/section_header.dart';
import 'package:flutter/material.dart';
import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:provider/provider.dart';

class ListBarangScreen extends StatefulWidget {
  const ListBarangScreen({Key? key}) : super(key: key);

  @override
  State<ListBarangScreen> createState() => _ListBarangScreenState();
}

class _ListBarangScreenState extends State<ListBarangScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.initializeDatabase(); 
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   dbHelper.close();
  // }

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
                delegate: ItemBarangSearch(dbHelper),
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
                'Menu Transaksi',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          const SectionHeader(title: 'LIST BARANG'), 
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<List<TransactionWithItems>>(
                  stream: dbHelper.getAllTransactionsWithItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Tidak ada data barang.'));
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
                          if (itemData != null) {
                          // Jika itemData tidak null,
                            return Card_barang(transaction: transaction, item: itemData);
                          } else {
                            // Jika itemData nya null,
                            return Card_barang(transaction: transaction, item: null);
                          }
                        },
                      );
                    }
                  },
              ),
          ),
        ],
      ),
      floatingActionButton: Actionsbutton(onPressed: () { 
        Navigator.pushNamed(context, '/transaksi');
      },),
    );
  }
}
