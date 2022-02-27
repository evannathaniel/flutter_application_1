import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

import 'month.dart';
import 'year.dart';

class Statistik extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatistikState();
  }
}

class _StatistikState extends State<Statistik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()))),
            title: Text('Statistik')),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatistikBulanan()));
              },
              child: Text('Month'),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatistikTahunan()));
              },
              child: Text('Year'),
            ),
          ])
        ]));
  }
}
