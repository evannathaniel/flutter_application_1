import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/pemasukan.dart';
import 'package:flutter_application_1/class/pengeluaran.dart';
import 'package:flutter_application_1/ui/Transaksi/detailTransaksiBulanan.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:intl/intl.dart';

class TransaksiBulanan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransaksiBulananState();
  }
}

class _TransaksiBulananState extends State<TransaksiBulanan> {
  int month = 1;
  int year = 2022;
  //DateTime? tanggal;
  int jumlahHari = 31;
  var hari1 = <int>[];
  var hari2 = <int>[];
  Map<int, double> jumlahPemasukan = {};
  Map<int, double> jumlahPengeluaran = {};
  final f = new DateFormat('yyyy-MM-dd');

  final months = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'Mei': 5,
    'Jun': 6,
    'Jul': 7,
    'Agt': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Des': 12
  };
  final years = {
    '2015': 2015,
    '2016': 2016,
    '2017': 2017,
    '2018': 2018,
    '2019': 2019,
    '2020': 2020,
    '2021': 2021,
    '2022': 2022,
    '2023': 2023
  };
  Widget showPengeluaran() {
    jumlahPengeluaran.clear();
    hari1.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    for (Pengeluaran p in listPengeluaran) {
      if (p.tanggal.year == year) {
        if (p.tanggal.month == month) {
          for (int i = 1; i <= jumlahHari; i++) {
            if (p.tanggal.day == i) {
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
    hari1 = jumlahPengeluaran.keys.toList();
    if (jumlahPengeluaran.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: jumlahPengeluaran.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.arrow_upward, size: 30),
                      title: Text(DateFormat('yyyy-MM-dd')
                          .format(DateTime(year, month, hari1[index]))),
                      subtitle: Text(currencyFormatter
                          .format(jumlahPengeluaran[hari1[index]])
                          .toString()),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => showDetailTransaksiBulanan(
                                  id: 1, d: DateTime(year, month))));
                    }),
              ],
            ));
          });
    } else {
      return (Text("empty"));
    }
  }

  Widget showPemasukan() {
    jumlahPemasukan.clear();
    hari2.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    for (Pemasukan p in listPemasukan) {
      if (p.tanggal.month == month) {
        for (int i = 1; i <= jumlahHari; i++) {
          if (p.tanggal.day == i) {
            if (jumlahPemasukan.containsKey(i)) {
              jumlahPemasukan.update(i, (value) => value += p.jumlah);
            } else {
              jumlahPemasukan[i] = p.jumlah;
            }
          }
        }
      }
    }
    hari2 = jumlahPemasukan.keys.toList();
    if (jumlahPemasukan.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: jumlahPemasukan.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(child: 
                ListTile(
                  leading: Icon(Icons.arrow_upward, size: 30),
                  title: Text(DateFormat('yyyy-MM-dd')
                      .format(DateTime(year, month, hari2[index]))),
                  subtitle: Text(currencyFormatter
                      .format(jumlahPemasukan[hari2[index]])
                      .toString()),
                ),
               onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => showDetailTransaksiBulanan(
                                  id: 1, d: DateTime(year, month))));
                    })
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
            title: Text('Transaksi Bulanan')),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                'Transaksi Bulanan',
                textAlign: TextAlign.center,
              )),
          Row(children: <Widget>[
            Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 2.1,
                child: Column(children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'Pilih Bulan',
                        textAlign: TextAlign.center,
                      )),
                  DropdownButton<int>(
                    value: month,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    items: months.entries
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
                        month = newValue!;
                      });
                    },
                  ),
                ])),
            Column(children: <Widget>[
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
            ]),
          ]),
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
        ]));
  }
}
