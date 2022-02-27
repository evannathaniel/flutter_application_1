import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/ui/Fitur/addLoans.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../class/loan.dart';
import 'LoansDetail.dart';
import 'fitur.dart';

class Loans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoansState();
  }
}

class _LoansState extends State<Loans> {
  String _txtcari = '';
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/loan.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    listLoans.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var g in json['data']) {
        Loan gs = Loan.fromJson(g);
        listLoans.add(gs);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget showLoans(List Loans) {
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    if (Loans.length > 0) {
      return ListView.builder(
          itemCount: Loans.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.money, size: 30),
                  title: GestureDetector(
                      child: Text(Loans[index].nama),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailLoan(loan_id: Loans[index].id)));
                      }),
                  subtitle: Text(currencyFormatter
                      .format(Loans[index].jumlah - Loans[index].jumlahCicilan)
                      .toString()),
                ),
              ],
            ));
          });
    } else {
      return Text("Tidak ada data Tagihan");
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
        title: Text('List Loans'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  labelText: 'Cari:',
                ),
                onChanged: (value) {
                  _txtcari = value;
                  bacaData();
                },
              )),
          SizedBox(
            height: 10,
          ),
          Container(
              height: MediaQuery.of(context).size.height - 200,
              child: showLoans(listLoans)),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddLoans()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
