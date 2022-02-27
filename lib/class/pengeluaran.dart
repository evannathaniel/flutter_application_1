
import 'package:flutter_application_1/class/detailPengeluaran.dart';

class Pengeluaran{
  int id;
  String nama;
  int kategori;
  double jumlah;
  DateTime tanggal;
  late final List? detail;
  Pengeluaran({required this.id,required this.nama,required this.kategori,required this.jumlah,required this.tanggal,this.detail});
  
  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
        id: json['id'],
        nama: json['nama'],
        kategori: json['kategori'],
        jumlah: double.parse(json['jumlah'].toString()),
        tanggal:DateTime.parse(json['tanggal']),
        detail: json['detail']);
        
  }
}

var listPengeluaran = <Pengeluaran>[];