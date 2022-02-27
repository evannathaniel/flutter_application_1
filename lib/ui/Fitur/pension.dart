import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'fitur.dart';

class PensionFund extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PensionFundState();
  }
}

class _PensionFundState extends State<PensionFund> {
  final _formKey = GlobalKey<FormState>();
  final currencyFormatter = NumberFormat.currency(locale: 'ID');
  int _umurSekarang = 0;
  int _umurPensiun = 0;
  int _umurNabung = 0;
  int _selisihumur = 0;
  num _period = 0;
  num _inflasi = 4.23;
  num _angkaHH = 0;
  num _biayaHidup = 0;
  num _tabungan = 0;
  num _waktuNabung = 0;
  num hasilperbulan = 0;
  num hasiltotal = 0;
  String _jenisKelamin = "Perempuan";
  String formattedhasil = "";
  String formattedtabungan = "";
  String formattedtabunganB = "";
  String texthasil = "";
  void showPensionFund() {
    setState(() {
      if (_jenisKelamin == "Perempuan") {
        _angkaHH = 69.8;
      } else if (_jenisKelamin == "Laki - Laki") {
        _angkaHH = 73.3;
      }
      _period = _angkaHH - _umurPensiun;
      _waktuNabung = _umurPensiun - _umurNabung;
      _selisihumur = _umurPensiun - _umurSekarang;
      hasilperbulan = _biayaHidup * pow((1 + (_inflasi / 100)), _selisihumur);
      hasiltotal = (hasilperbulan * 12) * _period;
      _tabungan = hasiltotal / (_waktuNabung * 12);
      formattedhasil = currencyFormatter.format(hasiltotal);
      formattedtabunganB = currencyFormatter.format(hasilperbulan);
      formattedtabungan = currencyFormatter.format(_tabungan);
      texthasil = "Jumlah Uang Pensiun yang anda butuhkan adalah  " +
          formattedhasil +
          "\nJumlah Uang Pensiun anda perbulan adalah  " +
          formattedtabunganB +
          "\nJumlah yang harus ditabung jika anda menabung mulai umur " +
          _umurNabung.toString() +
          " adalah " +
          formattedtabungan +
          " perbulan";
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
        title: Text('Hitung Uang Pensiun'),
      ),
      body: Center(
          child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Umur Sekarang: (Tahun)',
                          ),
                          onChanged: (value) {
                            _umurSekarang = int.parse(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Umur Sekarang harus diisi ';
                            } else if (int.tryParse(value)!.isNaN) {
                              return 'Umur Sekarang harus diisi dengan angka';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Umur Mulai Nabung: (Tahun)',
                          ),
                          onChanged: (value) {
                            _umurNabung = int.parse(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Umur Mulai Nabung harus diisi ';
                            } else if (int.tryParse(value)!.isNaN) {
                              return 'Umur Mulai Nabung harus diisi dengan angka';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Umur Pensiun: (Tahun)',
                          ),
                          onChanged: (value) {
                            _umurPensiun = int.parse(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Umur pensiun harus diisi ';
                            } else if (int.tryParse(value)!.isNaN) {
                              return 'Umur pensiun harus diisi dengan angka';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Biaya Hidup sekarang: (perbulan)',
                          ),
                          onChanged: (value) {
                            _biayaHidup = int.parse(value);
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
                      child: Text("Jenis Kelamin"),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: DropdownButton<String>(
                          value: _jenisKelamin,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _jenisKelamin = newValue!;
                            });
                          },
                          items: <String>['Perempuan', 'Laki - Laki']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Harap Isian diperbaiki')));
                          } else {
                            showPensionFund();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                    Container(
                        child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(texthasil, maxLines: null)))
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
