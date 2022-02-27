
import 'package:flutter_application_1/class/kategori.dart';

class Budget{
  int id;
  int kategori;
  double jumlah;
  DateTime tanggal;
  Budget({required this.id,required this.kategori,required this.jumlah,required this.tanggal});
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
        id: json['id'],
        kategori: json['kategori'],
        jumlah: double.parse(json['jumlah'].toString()),
        tanggal: DateTime.parse(json['tanggal']) );
  }
}

var listBudget = <Budget>[];