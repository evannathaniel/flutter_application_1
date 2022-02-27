import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'fitur.dart';

class Invest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InvestState();
  }
}

class _InvestState extends State<Invest> {
  final _formKey = GlobalKey<FormState>();
  final currencyFormatter = NumberFormat.currency(locale: 'ID');
  int _jumlah = 0;
  int _jangkaWaktu = 0;
  int _return = 0;
  num hasil = 0;
  String formattedhasil = "";
  String texthasil = "";
  void showInvest() {
    setState(() {
      hasil = _jumlah * pow((1 + (_return / 100)), _jangkaWaktu);
      formattedhasil = currencyFormatter.format(hasil);
      texthasil = "Jumlah Investasi setelah " +
          _jangkaWaktu.toString() +
          " tahun = " +
          formattedhasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Fitur()))),
        title: Text('Hitung Investasi'),
      ),
      body: Center(
          child: ListView(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Jumlah: (IDR)',
                            ),
                            onChanged: (value) {
                              _jumlah = int.parse(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'jumlah harus diisi ';
                              } else if (int.tryParse(value)!.isNaN) {
                                return 'jumlah harus diisi dengan angka';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Jangka waktu: (Tahun)',
                            ),
                            onChanged: (value) {
                              _jangkaWaktu = int.parse(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'return harus diisi ';
                              } else if (int.tryParse(value)!.isNaN) {
                                return 'return harus diisi dengan angka';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Return yang ditawarkan: (%)',
                            ),
                            onChanged: (value) {
                              _return = int.parse(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'return harus diisi ';
                              } else if (int.tryParse(value)!.isNaN) {
                                return 'return harus diisi dengan angka';
                              }
                              return null;
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Harap Isian diperbaiki')));
                            } else {
                              showInvest();
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(15), child: Text(texthasil))
                    ],
                  ),
                )
              ],
            ))
      ])),
    );
  }
}
