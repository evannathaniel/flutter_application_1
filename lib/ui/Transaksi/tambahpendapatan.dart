import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'transaksi.dart';

class TambahPendapatan extends StatefulWidget {
  final DateTime d;
  TambahPendapatan({Key? key, required this.d}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TambahPendapatanState();
  }
}

class _TambahPendapatanState extends State<TambahPendapatan> {
  var dropdownValue = listKategori.asMap()[0];
  TextEditingController _name_cont = TextEditingController();
  TextEditingController _jml_cont = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name_cont.text = "";
    _jml_cont.text = "";
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("user_id") ?? '';
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/newpendapatan.php"),
        body: {
          'id_user': id,
          'nama': _name_cont.text,
          'kategori': dropdownValue!.id.toString(),
          'jumlah': _jml_cont.text,
          'tanggal': this.widget.d.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Tambah Pendapatan'),
                  content: Text('Pendapatan telah ditambah'),
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
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transaksi()))),
            title: Text('Tambah Pendapatan ' +
                DateFormat('yyyy/MM/dd').format(this.widget.d))),
        body: Container(
            child: ListView(children: <Widget>[
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
            padding: EdgeInsets.all(10),
            child: Text("Kategori"),
          ),
          Padding(
              padding: EdgeInsets.all(10),
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
                items: listKategori.map((Kategori value) {
                  return DropdownMenuItem<Kategori>(
                    value: value,
                    child: Text(value.nama.toString()),
                  );
                }).toList(),
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  submit();
                },
                child: Text('Submit'),
              ))
        ])));
  }
}
