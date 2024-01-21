import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/provider/transaction_provider.dart';
import 'package:app_transaksi_barang/provider/user_provider.dart';
import 'package:app_transaksi_barang/screen/List_barang.dart';
import 'package:app_transaksi_barang/screen/form_barang.dart';
import 'package:app_transaksi_barang/screen/form_edit_transaksi.dart';
import 'package:app_transaksi_barang/screen/form_transaksi.dart';
import 'package:app_transaksi_barang/screen/form_edit_barang.dart';
import 'package:app_transaksi_barang/screen/home_screen.dart';
import 'package:app_transaksi_barang/screen/login.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(), 
        ),
        home: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
            return userProvider.userEmail != null ? const HomeScreen() : const LoginPage();
          },
        ),
        routes: {
          '/login_page': (context) => const LoginPage(),
          '/home_page': (context) => const HomeScreen(),
          '/transaksi': (context) => const FormTransaksi(),
          '/barang': (context) => const FormBarang(),
          '/form_edit_barang': (context) => const FormEditBarang(),
          '/form_edit_transaksi': (context) => const FormEditTransaksi(),
          '/list_barang': (context) => const ListBarangScreen(),
        },
      ),
    );
  }
}
 