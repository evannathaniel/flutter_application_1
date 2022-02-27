import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/budget.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksitahunan.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../class/pemasukan.dart';
import '../../class/pengeluaran.dart';
import 'detailBudget.dart';
import 'showDetailPengeluaran.dart';
import 'tambahpendapatan.dart';
import 'tambahpengeluaran.dart';
import 'transaksibulanan.dart';

class Transaksi extends StatefulWidget {
  static const String routeName = '/transaksi';
  @override
  State<StatefulWidget> createState() {
    return _TransaksiState();
  }
}

class _TransaksiState extends State<Transaksi> {
  DateTime date = DateTime.now();
  var listPemasukan1 = <Pemasukan>[];
  var listPengeluaran1 = <Pengeluaran>[];
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/pendapatan.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData2() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/budget.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData1() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/pengeluaran.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    listPemasukan.clear();
    listPengeluaran.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Pemasukan pm = Pemasukan.fromJson(p);
        listPemasukan.add(pm);
      }
      setState(() {});
    });
    Future<String> data1 = fetchData1();
    data1.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Pengeluaran pm = Pengeluaran.fromJson(p);
        listPengeluaran.add(pm);
      }
      setState(() {});
    });
  }

  bacaData2() {
    listBudget.clear();
    Future<String> data = fetchData2();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Budget pm = Budget.fromJson(p);
        listBudget.add(pm);
        print(pm.tanggal);
      }
      setState(() {});
    });
  }

  Widget showBudget() {
    double totalbudget = 0;
    double totalpengeluaran = 0;
    for(Pengeluaran p in listPengeluaran){
      if (p.tanggal.month == date.month && p.tanggal.year == date.year){
        totalpengeluaran +=p.jumlah;
      }
    }
    for (Budget b in listBudget) {
      if (b.tanggal.month == date.month && b.tanggal.year == date.year) {
        totalbudget += b.jumlah;
        
      }
    }
    totalbudget-=totalpengeluaran;
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    return Column(children: <Widget>[
      Text('Sisa Budget Anda Bulan Ini : ' +
          currencyFormatter.format(totalbudget).toString()),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => showDetailBudget(date: date)));
        },
        child: Text("Detail Budget"),
      )
    ]);
  }

  Widget showPemasukan() {
    listPemasukan1.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (listPemasukan.length > 0) {
      for (Pemasukan p in listPemasukan) {
        if (p.tanggal.day == date.day &&
            p.tanggal.month == date.month &&
            p.tanggal.year == date.year) {
          listPemasukan1.add(p);
        }
      }
      if (listPemasukan1.length > 0) {
        return ListView.builder(
            itemCount: listPemasukan1.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.arrow_upward, size: 20),
                    title: Text(
                        listPemasukan1[index].nama +
                            "\n" +
                            mapK[listPemasukan1[index].kategori - 1]!.nama,
                        style: TextStyle(fontSize: 14)),
                    subtitle: Text(currencyFormatter
                        .format(listPemasukan1[index].jumlah)
                        .toString()),
                  ),
                ],
              ));
            });
      } else {
        return Text("Empty");
      }
    } else {
      return Text("Empty");
    }
  }

  Widget showPengeluaran() {
    listPengeluaran1.clear();
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (listPengeluaran.length > 0) {
      for (Pengeluaran p in listPengeluaran) {
        if (p.tanggal.day == date.day &&
            p.tanggal.month == date.month &&
            p.tanggal.year == date.year) {
          listPengeluaran1.add(p);
        }
      }

      if (listPengeluaran1.length > 0) {
        return ListView.builder(
            itemCount: listPengeluaran1.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.arrow_downward_outlined, size: 20),
                        title: Text(
                            listPengeluaran1[index].nama +
                                "\n" +
                                mapK1[listPengeluaran1[index].kategori - 4]!
                                    .nama,
                            style: TextStyle(fontSize: 14)),
                        subtitle: Text(currencyFormatter
                            .format(listPengeluaran1[index].jumlah)
                            .toString()),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(listPengeluaran1[index].id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => showDetailPengeluaran(
                                      id: listPengeluaran1[index].id)));
                        },
                        child: Text("Detail"),
                      )
                    ],
                  ));
            });
      } else {
        return Text("Empty");
      }
    } else {
      return Text("Empty");
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
    bacaData2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()))),
            title: Text('Transaksi Harian')),
        body: Container(
          height: MediaQuery.of(context).size.height-100,
            child: ListView(children: <Widget>[
          Column(children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10), child: showBudget()),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(DateFormat('yyyy-MM-dd').format(date),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.deepPurple))),
            TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime.now(), onConfirm: (d) {
                    setState(() {
                      date = d;
                    });
                    bacaData();
                  }, currentTime: DateTime.now(), locale: LocaleType.id);
                },
                child: Text(
                  'Pilih Tanggal',
                  style: TextStyle(color: Colors.blue),
                )),
            Text("Pemasukan",
                style: TextStyle(fontSize: 14, color: Colors.blue)),
            SizedBox(height: 10),
            Container(
                constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: showPemasukan()),
            Text("Pengeluaran",
                style: TextStyle(fontSize: 14, color: Colors.red)),
            SizedBox(height: 10),
            Container(
                constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: MediaQuery.of(context).size.height / 3.5),
                child: showPengeluaran()),
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransaksiBulanan()));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          primary: Colors.purple),
                      child: Text(
                        'Transaksi Bulanan',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TransaksiTahunan()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(150, 50),
                            primary: Colors.purple),
                        child: Text('Transaksi Tahunan',
                            textAlign: TextAlign.center)),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: <Widget>[
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TambahPendapatan(d: date)));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50), primary: Colors.blue),
                      label: Text(
                        'Pendapatan',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TambahPengeluaran(
                                      d: date,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(150, 50), primary: Colors.red),
                      label: Text(
                        'Pengeluaran',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                ])),
          ])
        ])));
  }
}
