import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/provider/transaction_provider.dart';
import 'package:app_transaksi_barang/widget/bottom_widget.dart';
import 'package:app_transaksi_barang/widget/section_header.dart';
import 'package:app_transaksi_barang/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/custom_text_form_field.dart';

class FormTransaksi extends StatefulWidget {
  const FormTransaksi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormTransaksiState createState() => _FormTransaksiState();
}

class _FormTransaksiState extends State<FormTransaksi> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  late bool isUpdateSuccess;
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final TextEditingController kodebarangController = TextEditingController();
  final TextEditingController nobarangController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    dbHelper.initializeDatabase();
  }

  @override
  void dispose() {
    nomorController.dispose();
    tanggalController.dispose();
    kodeController.dispose();
    namaController.dispose();
    noTeleponController.dispose();
    kodebarangController.dispose();
    nobarangController.dispose();
    hargaController.dispose();
    jumlahController.dispose();
    totalController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          title: 'Data Transaksi',
          content: 'Data Transaksi berhasil diSimpan. 😊',
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
          content: 'Terjadi kesalahan saat menambahkan data transaksi.',
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(title: 'TRANSAKSI'),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Nomor',
                  controller: nomorController,
                  keyboardType: TextInputType.number,
                  hintText: '001',
                ),
                const SizedBox(height: 16.0),
                CustommTextFormField(
                  label: 'Tanggal',
                  controller: tanggalController,
                  keyboardType: TextInputType.text,
                  hintText: '01-Jan-2021',
                ),
                const SizedBox(height: 16.0),
                const SectionHeader(title: 'CUSTOMER'),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Kode',
                  controller: kodeController,
                  keyboardType: TextInputType.number,
                  hintText: '202101-0001',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Nama',
                  controller: namaController,
                  keyboardType: TextInputType.name,
                  hintText: 'Cust A',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'No Telepon',
                  controller: noTeleponController,
                  keyboardType: TextInputType.phone,
                  hintText: '081233356',
                ),
                const SizedBox(height: 16.0),
                const SectionHeader(title: 'BARANG'),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Kode Barang',
                  controller: kodebarangController,
                  keyboardType: TextInputType.text,
                  hintText: 'A001',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Nomor Barang',
                  controller: nobarangController,
                  keyboardType: TextInputType.number,
                  hintText: '01',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Harga',
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Jumlah',
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                  hintText: '1',
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  label: 'Total',
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  hintText: '200,000.000',
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try {
                        Provider.of<TransactionProvider>( context, listen: false).insertTransaction(
                        context,
                        nomorController,
                        tanggalController,
                        kodeController,
                        namaController,
                        noTeleponController,
                        kodebarangController,
                        nobarangController,
                        hargaController,
                        jumlahController,
                        totalController,
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
