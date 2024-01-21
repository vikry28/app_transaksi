import 'package:app_transaksi_barang/db/db_helper.dart';
import 'package:app_transaksi_barang/widget/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;


  final DatabaseHelper dbHelper = DatabaseHelper();

  UserProvider() {
    initializeDatabase();
    checkSavedUser();
  }

  Future<void> initializeDatabase() async {
    await dbHelper.initializeDatabase();
  }

  Future<void> checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserEmail = prefs.getString('userEmail');
    if (savedUserEmail != null) {
      _userEmail = savedUserEmail;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password, BuildContext context) async {
    try {
      var storedUserData = await dbHelper.getUser(email, password);

      if (storedUserData != null) {
        String storedPassword = storedUserData['password'];
        if (storedPassword == password) {
          await _saveUserAndShowDialog(context, email, 'Login Berhasil', 'Selamat datang di Aplikasi!');
        } else {
          _showErrorDialog(context, 'Login Gagal', 'Kata sandi salah. Silakan coba lagi.');
        }
      } else {
        await _handleUserAdded(context, email, password);
      }
    } catch (e) {
      _showErrorDialog(context, 'Login Gagal', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> _handleUserAdded(BuildContext context, String email, String password) async {
    await dbHelper.insertUser(email, password);
    // ignore: use_build_context_synchronously
    await _saveUserAndShowDialog(context, email, 'User Ditambahkan', 'Selamat datang di Aplikasi!');
  }

  Future<void> _saveUserAndShowDialog(BuildContext context, String email, String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', email);
    _userEmail = email;
    notifyListeners();
    // ignore: use_build_context_synchronously
    _showSuccessDialog(context, title, content);
  }

  void _showSuccessDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: title,
        content: content,
        onOkPressed: () { 
          Navigator.pushReplacementNamed(context, '/home_page',);
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        content: content,
      ),
    );
  }

  Future<void> updatePassword(String email, String newPassword) async {
    await dbHelper.updatePassword(email, newPassword);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    await dbHelper.logout();
    _userEmail = null;
    notifyListeners();
  }

  Future<void> deleteUsers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    await dbHelper.deleteusers();
    _userEmail = null;
    notifyListeners();
  }
}
