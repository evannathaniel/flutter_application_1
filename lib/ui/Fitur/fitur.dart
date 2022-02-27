import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/ui/Fitur/loans.dart';

import 'goals.dart';
import 'invest.dart';
import 'pension.dart';

class Fitur extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FiturState();
  }
}

class _FiturState extends State<Fitur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()))),
            title: Text('Fitur')),
        body: ListView(children: <Widget>[
          Column(children: [
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Goals()));
              },
              child: Text('Target'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 35),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Loans()));
              },
              child: Text('Tagihan'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 35),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Invest()));
              },
              child: Text('Hitung Investasi'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 35),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PensionFund()));
              },
              child: Text('Hitung Uang Pensiun'),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 35),
              ),
            ),
          ]),
        ]));
  }
}
