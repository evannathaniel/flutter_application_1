import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:http/http.dart' as http;

import '../../class/pengeluaran.dart';

class showDetailPengeluaran extends StatefulWidget {
  final int id;
  showDetailPengeluaran({Key? key, required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _showDetailPengeluaranState();
  }
}

class _showDetailPengeluaranState extends State<showDetailPengeluaran> {
  Pengeluaran? p;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.fun/flutter/160718008/TA/detailpengeluaran.php"),
        body: {'id': widget.id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      p = Pengeluaran.fromJson(json['data']);
      setState(() {});
    });
  }

  Widget tampilData() {
    if (p != null) {
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(p!.nama, style: TextStyle(fontSize: 25)),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(mapK1[p!.kategori - 4]!.nama,
                    style: TextStyle(fontSize: 15))),
            Padding(
                padding: EdgeInsets.all(10),
                child:
                    Text(p!.jumlah.toString(), style: TextStyle(fontSize: 15))),
            Padding(padding: EdgeInsets.all(10), child: Text("Detail:")),
            Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: p!.detail!.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new ListTile(
                      title: Text(p!.detail![index]['nama']),
                      subtitle: Text(p!.detail![index]['jumlah'].toString()),
                    );
                  }),
            )
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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Transaksi()))),
          title: const Text('Detail Pengeluaran'),
        ),
        body: ListView(children: <Widget>[tampilData()]));
  }
}
