import 'package:flutter_application_1/class/pengeluaran.dart';

class DetailPengeluaran {
  String nama;
  num subtotal;

  DetailPengeluaran({required this.nama, required this.subtotal});

  factory DetailPengeluaran.fromJson(Map<String, dynamic> json) {
    return DetailPengeluaran(
      nama: json['nama'],
      subtotal: json['jumlah']+.0,
    );
  }
}
