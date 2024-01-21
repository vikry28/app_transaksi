import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/provider/transaction_provider.dart';
import 'package:app_transaksi_barang/widget/bottom_widget.dart';
import 'package:app_transaksi_barang/widget/custom_text_form_field.dart';
import 'package:app_transaksi_barang/widget/section_header.dart';
import 'package:app_transaksi_barang/widget/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FormBarang extends StatefulWidget {
  const FormBarang({super.key});

  @override
  State<FormBarang> createState() => _FormBarangState();
}

class _FormBarangState extends State<FormBarang> {
  final dbHelper = DatabaseHelper();
  final formKiy = GlobalKey<FormState>();
  final TextEditingController _kodebarangC = TextEditingController();
  final TextEditingController _nobarangC = TextEditingController();
  final TextEditingController _haragbarangC = TextEditingController();
  final TextEditingController _jumlahC = TextEditingController();
  final TextEditingController _totalC = TextEditingController();
  late int transactionId;
  @override
  void initState() {
    super.initState();
    dbHelper.initializeDatabase(); // Memanggil metode initializeDatabase pada initState
  }


  @override
  void dispose() {
    _kodebarangC.dispose();
    _nobarangC.dispose();
    _haragbarangC.dispose();
    _jumlahC.dispose();
    _totalC.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Data Transaksi',
          content: 'Data Barang berhasil ditambahkan/disimpan. 😊',
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
          content: 'Terjadi kesalahan saat menyimpan data barang.', title: 'Error',
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
            key: formKiy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(title: 'BARANG'),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Kode Barang',
                  controller: _kodebarangC,
                  keyboardType: TextInputType.text,
                  hintText: 'A001',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Nomor Barang',
                  controller: _nobarangC,
                  keyboardType: TextInputType.number,
                  hintText: '01',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Harga',
                  controller: _haragbarangC,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Jumlah',
                  controller: _jumlahC,
                  keyboardType: TextInputType.number,
                  hintText: '1',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Total',
                  controller: _totalC,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: () async {
                    if (formKiy.currentState?.validate() ?? false) {
                      try {
                        Provider.of<TransactionProvider>(context, listen: false).insertItem(
                        _kodebarangC, _nobarangC, _haragbarangC, _jumlahC, _totalC, transactionId,
                      );
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