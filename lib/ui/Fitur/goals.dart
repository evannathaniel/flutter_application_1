import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/ui/Fitur/addGoals.dart';
import 'package:flutter_application_1/ui/Fitur/fitur.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../class/goal.dart';
import 'goalsDetail.dart';

class Goals extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoalsState();
  }
}

class _GoalsState extends State<Goals> {
  String _txtcari = '';
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/goal.php"),
        body: {'cari': _txtcari,
        'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    listGoals.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var g in json['data']) {
        Goal gs = Goal.fromJson(g);
        listGoals.add(gs);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget showGoals(List goals) {
    if (goals.length > 0) {
      final currencyFormatter = NumberFormat.currency(locale: 'ID');
      return ListView.builder(
          itemCount: goals.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.money, size: 30),
                  title: GestureDetector(
                      child: Text(goals[index].nama),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailGoal(goal_id: goals[index].id)));
                      }),
                  subtitle: Text(currencyFormatter
                      .format(goals[index].jumlahTarget -
                          goals[index].jumlahSekarang)
                      .toString()),
                ),
              ],
            ));
          });
    } else {
      return Text("Tidak ada data goals");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Fitur()))),
        title: Text('List Goals'),
      ),
      body: ListView(children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: 'Judul mengandung kata:',
                  ),
                  onChanged: (value) {
                    _txtcari = value;
                    bacaData();
                  },
                )),
            Container(
                height: MediaQuery.of(context).size.height - 200,
                child: showGoals(listGoals)),
          ],
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddGoals()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
