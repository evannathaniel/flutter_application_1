import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/loan.dart';
import 'package:flutter_application_1/ui/Fitur/loans.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailLoan extends StatefulWidget {
  final int? loan_id;
  DetailLoan({Key? key, required this.loan_id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailLoanState();
  }
}

class _DetailLoanState extends State<DetailLoan> {
  Loan? loan;
  String format = "";
  String format1 = "";
  String nama = "";
  TextEditingController _cicil = TextEditingController();
  @override
  void initState() {
    super.initState();
    for (Loan l in listLoans) {
      if (l.id == widget.loan_id) {
        loan = l;
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
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/cicil.php"),
        body: {
          'id_user': id,
          'nama': 'Nabung untuk ' + loan!.nama,
          'kategori': '12',
          'jumlah': _cicil.text,
          'tanggal': DateTime.now().toString(),
          'loan': this.widget.loan_id.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Menyicil'),
                  content: Text('Jumlah Cicilan akan tercatat di pengeluaran'),
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
    if (loan != null) {
      final currencyFormatter = NumberFormat.currency(locale: 'ID');
      nama = loan!.nama;
      var sisa = loan!.jumlah - loan!.jumlahCicilan;
      var beda;
      var jumlahperbulan;
      if (DateTime.now().isBefore(loan!.tanggal)) {
        beda = DateTime.now().difference(loan!.tanggal).inDays.abs() / 30;
        var roundedbeda = beda.round();
        if (roundedbeda > 0) {
          jumlahperbulan =
              currencyFormatter.format((sisa / roundedbeda)).toString();
        } else {
          jumlahperbulan = currencyFormatter.format(sisa).toString();
        }
      } else {
        jumlahperbulan = " Waktu membayar sudah lewat";
      }
      format = DateFormat('yyyy-MM-dd').format(loan!.tanggal);
      format1 = DateFormat('yyyy-MM-dd').format(DateTime(
          DateTime.now().year, DateTime.now().month, loan!.jatuhTempo));
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(loan!.nama, style: TextStyle(fontSize: 25)),
            
            Padding(
                padding: EdgeInsets.all(10),
                child: Text('Tanggal deadline: ' + format,
                    style: TextStyle(fontSize: 20))),Padding(
                padding: EdgeInsets.all(10),
                child: Text('Tanggal jatuh tempo bulan ini: ' + format1,
                    style: TextStyle(fontSize: 15))),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Jumlah Tagihan:" +
                    currencyFormatter.format(loan!.jumlah).toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Jumlah Cicilan:" +
                    currencyFormatter.format(loan!.jumlahCicilan).toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text("Sisa Tagihan:" +
                    currencyFormatter
                        .format((loan!.jumlah - loan!.jumlahCicilan))
                        .toString())),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Jumlah yang harus ditabung perbulan : " +
                      currencyFormatter
                          .format((loan!.jumlahPerbulan))
                          .toString(),
                  maxLines: null,
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    width: 200, child: Text("Keterangan:" + loan!.keterangan))),
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
                  context, MaterialPageRoute(builder: (context) => Loans()))),
          title: const Text('Detail Tagihan'),
        ),
        body: ListView(children: <Widget>[
          tampilData(),
          Padding(padding: EdgeInsets.all(10), child: Text("Mulai menyicil:")),
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
