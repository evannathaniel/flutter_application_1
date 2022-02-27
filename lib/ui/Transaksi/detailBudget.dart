import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/budget.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/class/pengeluaran.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showDetailBudget extends StatefulWidget {
  final DateTime date;
  showDetailBudget({Key? key, required this.date}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _showDetailBudgetState();
  }
}

class _showDetailBudgetState extends State<showDetailBudget> {
  late DateTime date;
  var dropdownValue = listKategori1.asMap()[0];
  var listBudget1 = <Budget>[];
  TextEditingController _jml_cont = TextEditingController();
  late DateTime month;
  String status = '';
  int idbudget = 0;
  @override
  void initState() {
    super.initState();
    bacaData();
    _jml_cont.text = "";
    date = this.widget.date;
    month = DateTime(date.year, date.month);
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("user_id") ?? '';
    for (Budget b in listBudget) {
      if (b.tanggal == month && b.kategori == dropdownValue!.id) {
        status = 'edit';
        idbudget = b.id;
      } else {
        status = 'new';
      }
    }
    print(status);
    if (status == 'new') {
      final response = await http.post(
          Uri.parse("https://ubaya.fun/flutter/160718008/TA/newbudget.php"),
          body: {
            'id_user': id,
            'kategori': dropdownValue!.id.toString(),
            'jumlah': _jml_cont.text,
            'tanggal': month.toString(),
          });
      if (response.statusCode == 200) {
        print(month.toString() + '  ' + dropdownValue!.id.toString());
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Atur Budget'),
                    content: Text('Budget telah diatur'),
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
    } else {
      final response = await http.post(
          Uri.parse("https://ubaya.fun/flutter/160718008/TA/editbudget.php"),
          body: {
            'id': idbudget.toString(),
            'jumlah': _jml_cont.text,
          });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Text('Atur Budget'),
                    content: Text('Budget telah diatur'),
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
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/budget.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    listBudget.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Budget pm = Budget.fromJson(p);
        listBudget.add(pm);
      }
      setState(() {});
    });
  }

  Widget tampilData() {
    listBudget1.clear();
    double totalp=0;
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (listBudget.length > 0) {
      for (Budget p in listBudget) {
        if (p.tanggal.month == this.widget.date.month &&
            p.tanggal.year == this.widget.date.year) {
          for (Pengeluaran p1 in listPengeluaran) {
            if (p1.tanggal.month == this.widget.date.month &&
                p1.tanggal.year == this.widget.date.year && p1.kategori==p.kategori) {
                  totalp+=p1.jumlah;
                }
          }
          p.jumlah-=totalp;
          listBudget1.add(p);
          totalp=0;
        }
      }
      if (listBudget1.length > 0) {
        return ListView.builder(
            itemCount: listBudget.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.arrow_upward, size: 20),
                    title: Text(mapK1[listBudget[index].kategori - 4]!.nama,
                        style: TextStyle(fontSize: 14)),
                    subtitle: Text(currencyFormatter
                        .format(listBudget[index].jumlah)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Transaksi()))),
          title: const Text('Detail Budget'),
        ),
        body: Container(
            padding: EdgeInsets.all(50),
            height: MediaQuery.of(context).size.height - 100,
            child: ListView(children: <Widget>[
              Container(
                  constraints: BoxConstraints(
                      minHeight: 50,
                      maxHeight: MediaQuery.of(context).size.height / 3.5),
                  child: tampilData()),
              SizedBox(
                height: 30,
              ),
              Text('Atur Budget'),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: _jml_cont,
                    onSubmitted: (v) {
                      _jml_cont.text = v;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Masukan Jumlah "),
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
