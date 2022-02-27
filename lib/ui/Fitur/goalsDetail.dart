import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/goal.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'goals.dart';

class DetailGoal extends StatefulWidget {
  final int goal_id;
  DetailGoal({Key? key, required this.goal_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailGoalState();
  }
}

class _DetailGoalState extends State<DetailGoal> {
  Goal? goal;
  String format = "";
  String nama = "";
  TextEditingController _cicil = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (Goal g in listGoals){
      if(g.id == widget.goal_id){
        goal =g;
      }
    }
   
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("user_id") ?? '';
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/nabung.php"),
        body: {
          'id_user': id,
          'nama': 'Nabung untuk ' + goal!.nama,
          'kategori': '11',
          'jumlah': _cicil.text,
          'tanggal': DateTime.now().toString(),
          'goal': this.widget.goal_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Menabung'),
                  content: Text('Jumlah Tabungan akan tercatat di pengeluaran'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget tampilData() {
    nama = goal!.nama;
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    nama = goal!.nama;
    var sisa = goal!.jumlahTarget - goal!.jumlahSekarang;
    var beda;
    var jumlahperbulan;
    if (DateTime.now().isBefore(goal!.tanggal)) {
      beda = DateTime.now().difference(goal!.tanggal).inDays.abs() / 30;
      var roundedbeda = beda.round();
      jumlahperbulan =
          currencyFormatter.format((sisa / roundedbeda)).toString();
    } else {
      jumlahperbulan = " Waktu menabung sudah lewat";
    }

    format = DateFormat('yyyy-MM-dd').format(goal!.tanggal);
    if (goal != null) {
      format = DateFormat('yyyy-MM-dd').format(goal!.tanggal);
      final currencyFormatter = NumberFormat.currency(locale: 'ID');
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(goal!.nama, style: TextStyle(fontSize: 25)),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(format, style: TextStyle(fontSize: 20))),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Jumlah Target: " +
                    currencyFormatter.format(goal!.jumlahTarget).toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Terkumpul: " +
                    currencyFormatter.format(goal!.jumlahSekarang).toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    "Sisa: " + currencyFormatter.format((sisa)).toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Jumlah yang harus ditabung perbulan : " + jumlahperbulan,
                  maxLines: null,
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    width: 200,
                    child: Text("Keterangan: " + goal!.keterangan))),
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Goals()))),
          title: const Text('Detail Target'),
        ),
        body: ListView(children: <Widget>[
          tampilData(),
          Padding(padding: EdgeInsets.all(10), child: Text("Mulai menabung:")),
          Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _cicil,
                onSubmitted: (v) {
                  _cicil.text = v;
                  v = "";
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Masukan Jumlah"),
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
        ]));
  }
}
