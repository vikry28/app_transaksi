import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/provider/transaction_provider.dart';
import 'package:app_transaksi_barang/widget/bottom_widget.dart';
import 'package:app_transaksi_barang/widget/custom_text_form_field.dart';
import 'package:app_transaksi_barang/widget/section_header.dart';
import 'package:app_transaksi_barang/widget/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FormEditBarang extends StatefulWidget {
  const FormEditBarang({super.key});

  @override
  State<FormEditBarang> createState() => _FormEditBarangState();
}

class _FormEditBarangState extends State<FormEditBarang> {
  final dbHelper = DatabaseHelper();
  final _formKeyyy = GlobalKey<FormState>();
  final TextEditingController _kodebarangController = TextEditingController();
  final TextEditingController _nobarangController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  late Map<String, dynamic> transactionData;
  late Map<String, dynamic>? item;
  late int transactionId;
  int? parseTransactionId(dynamic value) {
    if (value == null) {
      return null; 
    }
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    transactionId = 0; 
    dbHelper.initializeDatabase(); // Memanggil metode initializeDatabase pada initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      setState(() {
        transactionData = arguments;
        item = arguments['item'] ?? {};
        transactionId = parseTransactionId(transactionData['transactionId'])!;
        print(transactionId);
        _kodebarangController.text = item!['item_code'] ?? '';
        _nobarangController.text = item!['item_number'] ?? '';
        _hargaController.text = item!['price']?.toString() ?? '';
        _jumlahController.text = item!['quantity']?.toString() ?? '';
        _totalController.text = item!['total']?.toString() ?? '';
      });
    }
  }

   @override
  void dispose() {
    _kodebarangController.dispose();
    _nobarangController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Update Barang',
          content: 'Data Barang berhasil diupdate. 😊',
          onOkPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ErrorDialog(
          title: 'Error',
          content: 'Terjadi kesalahan saat mengupdate data barang.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          child: Form(
            key: _formKeyyy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(title: 'BARANG'),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Kode Barang',
                  controller: _kodebarangController,
                  keyboardType: TextInputType.text,
                  hintText: 'A001',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Nomor Barang',
                  controller: _nobarangController,
                  keyboardType: TextInputType.number,
                  hintText: '01',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Harga',
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Jumlah',
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  hintText: '1',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Total',
                  controller: _totalController,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_formKeyyy.currentState?.validate() ?? false) {
                      try {
                        Provider.of<TransactionProvider>(context, listen: false).updateItem(
                      _kodebarangController, _nobarangController, _hargaController, _jumlahController, _totalController
                      ,transactionId);
                        _showSuccessDialog(context);
                      } catch (error) {
                        _showErrorDialog(context);
                      }
                    }
                  },
                  buttonText: 'Simpan',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}