import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/detailPengeluaran.dart';
import 'package:flutter_application_1/ui/Transaksi/tambahpengeluaran.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:http/http.dart' as http;

class TambahDetailPengeluaran extends StatefulWidget {
  final int id;
  TambahDetailPengeluaran({Key? key, required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TambahDetailPengeluaranState();
  }
}

class _TambahDetailPengeluaranState extends State<TambahDetailPengeluaran> {
  var detail = <DetailPengeluaran>[];
  TextEditingController _name_cont = TextEditingController();
  TextEditingController _jml_cont = TextEditingController();
  @override
  void initState() {
    super.initState();
    _name_cont.text = "";
    _jml_cont.text = "";
  }

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160718008/TA/newdetailpengeluaran.php"),
        body: {
          'id_pengeluaran': this.widget.id.toString(),
          'nama': _name_cont.text,
          'jumlah': _jml_cont.text,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Tambah Detail Penngeluaran'),
                  content: Text('Detail Pengeluaran telah ditambah'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        _jml_cont.clear();
                        _name_cont.clear();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Transaksi()))),
            title: Text('Detail Pengeluaran')),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _name_cont,
                onSubmitted: (v) {
                  _name_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Masukan Nama "),
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _jml_cont,
                onSubmitted: (v) {
                  _jml_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Masukan Jumlah "),
              )),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('Tambah Detail lagi'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    submit();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Transaksi()));
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ]));
  }
}
