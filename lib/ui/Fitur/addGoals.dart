import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'goals.dart';

class AddGoals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddGoalsState();
  }
}

class _AddGoalsState extends State<AddGoals> {
  // ignore: non_constant_identifier_names
  TextEditingController _goals_name_cont = TextEditingController();
  TextEditingController _goals_jmlTarget_cont = TextEditingController();
  TextEditingController _goals_keterangan_cont = TextEditingController();
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
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/newgoal.php"),
        body: {
          'id_user': prefs.getString("user_id") ?? '',
          'nama': _goals_name_cont.text,
          'jumlah': _goals_jmlTarget_cont.text,
          'jumlah_cicilan': '0',
          'tanggal': date.toString(),
          'keterangan': _goals_keterangan_cont.text,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Tambah Target'),
                  content: Text('Target telah ditambah'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Goals()));
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

    _goals_name_cont.text = "";
    _goals_jmlTarget_cont.text = "";
    _goals_keterangan_cont.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Goals()))),
        title: Text('Add goals'),
      ),
      body: ListView(children: <Widget>[
        Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _goals_name_cont,
                onSubmitted: (v) {
                  _goals_name_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Nama Target"),
              )),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _goals_jmlTarget_cont,
                onSubmitted: (v) {
                  _goals_jmlTarget_cont.text = v;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Masukan Jumlah Target"),
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
                style: TextStyle(color: Colors.blue, fontSize: 20),
              )),
          Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: TextStyle(color: Colors.blue),
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _goals_keterangan_cont,
                onSubmitted: (v) {
                  _goals_keterangan_cont.text = v;
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
                  icon: Icon(Icons.add),
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
