import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/class/pemasukan.dart';
import 'package:flutter_application_1/ui/Transaksi/showDetailPengeluaran.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:intl/intl.dart';

import '../../class/pengeluaran.dart';

class showDetailTransaksiBulanan extends StatefulWidget {
  final int id;
  final DateTime d;
  showDetailTransaksiBulanan({Key? key, required this.id, required this.d})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _showDetailTransaksiBulananState();
  }
}

class _showDetailTransaksiBulananState
    extends State<showDetailTransaksiBulanan> {
  var listPengeluaran1 = <Pengeluaran>[];
  var listPemasukan1 = <Pemasukan>[];
  late DateTime date;
  late int idx;
  String text = 'Pemasukan';

  @override
  void initState() {
    super.initState();
    date = this.widget.d;
    idx = this.widget.id;
    if (idx == 1) {
      text = 'Pengeluaran';
      print(idx);
    } else {
      text = 'Pemasukan';
    }
  }

  Widget tampilData() {

    if (idx == 1) {
      listPengeluaran1.clear();
      final currencyFormatter = NumberFormat.currency(locale: 'ID');
      if (listPengeluaran.length > 0) {
        for (Pengeluaran p in listPengeluaran) {
          if (p.tanggal.month == date.month && p.tanggal.year == date.year) {
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
                          leading:
                              Icon(Icons.arrow_downward_outlined, size: 20),
                          title: Text(
                              listPengeluaran1[index].nama +
                                  "\n" +
                                  mapK1[listPengeluaran1[index].kategori - 4]!
                                      .nama,
                              style: TextStyle(fontSize: 14)),
                          subtitle: Text(currencyFormatter
                              .format(listPengeluaran1[index].jumlah)
                              .toString()+"\n"+DateFormat('yyyy-MM-dd').format(listPengeluaran1[index].tanggal)),
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
    } else {
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
                          .toString()+"\n"+DateFormat('yyyy-MM-dd').format(listPemasukan1[index].tanggal)),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Transaksi()))),
          title: const Text('Detail Transaksi Bulanan'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height - 100,
          child: ListView(children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  ' Detail ' + text,
                  textAlign: TextAlign.center,
                )),
            Container(
                padding: EdgeInsets.only(top: 50),
                constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: MediaQuery.of(context).size.height - 100),
                child: tampilData()),
          ]),
        ));
  }
}
