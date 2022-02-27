
import 'package:flutter_application_1/class/kategori.dart';

class Pemasukan{
  int id;
  String nama;
  int kategori;
  double jumlah;
  DateTime tanggal;
  Pemasukan({required this.id,required this.nama,required this.kategori,required this.jumlah,required this.tanggal});
  factory Pemasukan.fromJson(Map<String, dynamic> json) {
    return Pemasukan(
        id: json['id'],
        nama: json['nama'],
        kategori: json['kategori'],
        jumlah: double.parse(json['jumlah'].toString()),
        tanggal: DateTime.parse(json['tanggal']) );
  }
}

var listPemasukan = <Pemasukan>[];