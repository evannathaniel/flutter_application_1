import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loans.dart';

class AddLoans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddLoansState();
  }
}

class _AddLoansState extends State<AddLoans> {
  // ignore: non_constant_identifier_names
  TextEditingController _loans_name_cont = TextEditingController();
  TextEditingController _loans_jumlah_cont = TextEditingController();
  TextEditingController _loans_keterangan_cont = TextEditingController();
  TextEditingController _loans_jatuhTempo_cont = TextEditingController();
  TextEditingController _loans_perBulan_cont = TextEditingController();
  DateTime date = DateTime.now();
  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/newloan.php"),
        body: {
          'id_user': prefs.getString("user_id") ?? '',
          'nama': _loans_name_cont.text,
          'jumlah': _loans_jumlah_cont.text,
          'jumlah_cicilan': '0',
          'tanggal': date.toString(),
          'keterangan': _loans_keterangan_cont.text,
          'jatuhTempo': _loans_jatuhTempo_cont.text,
          'perBulan' : _loans_perBulan_cont.text
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Tambah Tagihan'),
                  content: Text('Tagihan telah ditambah'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Loans()));
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
  void initState() {
    // TODO: implement initState
    super.initState();

    _loans_name_cont.text = "";
    _loans_jumlah_cont.text = "";
    _loans_keterangan_cont.text = "";
    _loans_jatuhTempo_cont.text = "";
    _loans_perBulan_cont.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Loans()))),
        title: Text('Tambah Tagihan'),
      ),
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _loans_name_cont,
                onSubmitted: (v) {
                  _loans_name_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Nama Tagihan"),
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _loans_jumlah_cont,
                onSubmitted: (v) {
                  _loans_jumlah_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Jumlah Tagihan"),
              )),
          TextButton(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(3000, 12, 31), onConfirm: (d) {
                  setState(() {
                    date = d;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.id);
              },
              child: Text(
                'Pilih Tanggal',
                style: TextStyle(color: Colors.blue),
              )),
          Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: TextStyle(color: Colors.blue),
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _loans_jatuhTempo_cont,
                onSubmitted: (v) {
                  _loans_name_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Tanggal Tempo, misal = 28"),
              )),
              Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _loans_perBulan_cont,
                onSubmitted: (v) {
                  _loans_name_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Jumlah Cicilan Tiap Bulan"),
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _loans_keterangan_cont,
                onSubmitted: (v) {
                  _loans_keterangan_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Keterangan"),
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton.icon(
                  icon: Icon(Icons.next_plan),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                    backgroundColor:
                        MaterialStateProperty.resolveWith(getButtonColor),
                  ),
                  onPressed: () {
                    submit();
                  },
                  label: Text('SUBMIT'))),
        ])
      ]),
    );
  }
}
