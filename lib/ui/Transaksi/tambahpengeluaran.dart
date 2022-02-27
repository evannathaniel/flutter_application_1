import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tambahDetailPengeluaran.dart';

class TambahPengeluaran extends StatefulWidget {
  final DateTime d;
  TambahPengeluaran({Key? key, required this.d}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TambahPengeluaranState();
  }
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  var dropdownValue = listKategori1.asMap()[0];
  TextEditingController _name_cont = TextEditingController();

  int id = 0;

  @override
  void initState() {
    super.initState();
    _name_cont.text = "";
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/newpengeluaran.php"),
        body: {
          'id_user': prefs.getString("user_id") ?? '',
          'nama': _name_cont.text,
          'kategori': dropdownValue!.id.toString(),
          'jumlah': '0',
          'tanggal': this.widget.d.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      id = json['id'];
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
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transaksi()))),
            title: Text('TambahPengeluaran ' +DateFormat('yyyy/MM/dd').format(this.widget.d))),
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
            padding: EdgeInsets.all(10),
            child: Text("Kategori"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: DropdownButton<Kategori>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Kategori? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: listKategori1.map((Kategori value) {
                return DropdownMenuItem<Kategori>(
                  value: value,
                  child: Text(value.nama.toString()),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 150),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    submit();
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('Tambah Pengeluaran'),
                              content: Text('Penngeluaran telah ditambah'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TambahDetailPengeluaran(
                                                    id: id)));
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                  },
                  child: Text('Tambah detail'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    submit();
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('Tambah Pengeluaran'),
                              content: Text('Penngeluaran telah ditambah'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'OK');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Transaksi()));
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ));
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          )
        ]));
  }
}
