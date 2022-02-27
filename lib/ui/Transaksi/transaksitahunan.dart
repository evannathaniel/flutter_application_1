import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/pemasukan.dart';
import 'package:flutter_application_1/class/pengeluaran.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:intl/intl.dart';

class TransaksiTahunan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransaksiTahunanState();
  }
}

class _TransaksiTahunanState extends State<TransaksiTahunan> {
  int year = DateTime.now().year;
  Map<int, double> jumlahPemasukan = {};
  Map<int, double> jumlahPengeluaran = {};
  var bulan1;
  var bulan2;
  final years = {
    '2015': 2015,
    '2016': 2016,
    '2017': 2017,
    '2018': 2018,
    '2019': 2019,
    '2020': 2020,
    '2021': 2021,
    '2022': 2022,
    '2023': 2023,
    '2024': 2024
  };
  Widget showPengeluaran() {
    jumlahPengeluaran.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (listPengeluaran.length > 0) {
      for (Pengeluaran p in listPengeluaran) {
        if (p.tanggal.year == year) {
          for (int i = 1; i <= 12; i++) {
            if (p.tanggal.month == i) {
              if (jumlahPengeluaran.containsKey(i)) {
                jumlahPengeluaran.update(i, (value) => value += p.jumlah);
              } else {
                jumlahPengeluaran[i] = p.jumlah;
              }
            }
          }
        }
      }
    }
    bulan2 = jumlahPengeluaran.keys.toList();
    if (jumlahPengeluaran.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: bulan2.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: 
                Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.arrow_upward, size: 30),
                  title: Text(DateFormat('MM-yyyy')
                      .format(DateTime(year, bulan2[index]))),
                  subtitle: Text(currencyFormatter
                      .format(jumlahPengeluaran[bulan2[index]])
                      .toString()),
                ),
              ],
            ));
          });
    } else {
      return (Text("empty"));
    }
  }

  Widget showPemasukan() {
    jumlahPemasukan.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (listPemasukan.length > 0) {
      for (Pemasukan p in listPemasukan) {
        if (p.tanggal.year == year) {
          for (int i = 1; i <= 12; i++) {
            if (p.tanggal.month == i) {
              if (jumlahPemasukan.containsKey(i)) {
                jumlahPemasukan.update(i, (value) => value += p.jumlah);
              } else {
                jumlahPemasukan[i] = p.jumlah;
              }
            }
          }
        }
      }
    }
    bulan1 = jumlahPemasukan.keys.toList();
    if (jumlahPemasukan.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: bulan1.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: 
                Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.arrow_upward, size: 30),
                  title: Text(DateFormat('MM-yyyy')
                      .format(DateTime(year, bulan1[index]))),
                  subtitle: Text(currencyFormatter
                      .format(jumlahPemasukan[bulan1[index]])
                      .toString()),
                ),
              ],
            ));
          });
    } else {
      return (Text("empty"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transaksi()))),
            title: Text('Transaksi Tahunan')),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Transaksi Tahunan',
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Pilih Tahun',
                  textAlign: TextAlign.center,
                )),
            DropdownButton<int>(
              value: year,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              items: years.entries
                  .map<DropdownMenuItem<int>>(
                      (MapEntry<String, int> e) => DropdownMenuItem<int>(
                            value: e.value,
                            child: Text(e.key),
                          ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  jumlahPemasukan.clear();
                  jumlahPengeluaran.clear();
                  year = newValue!;
                });
              },
            ),
            Column(
            children: <Widget>[
              Text("Pemasukan"),
              Container(
                constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: showPemasukan()),
              Text("Pengeluaran"),
              Container(
                constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: showPengeluaran()),
            ],
          )
          ])
        ]));
  }
}
