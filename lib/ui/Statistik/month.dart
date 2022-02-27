import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/kategori.dart';
import 'package:flutter_application_1/ui/Statistik/statistik.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../class/pemasukan.dart';
import '../../class/pengeluaran.dart';

class StatistikBulanan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatistikBulananState();
  }
}

class _StatistikBulananState extends State<StatistikBulanan> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  double jumlahPengeluaran = 0;
  double jumlahPemasukan = 0;
  var listPengeluaran1 = <Pengeluaran>[];
  var listPemasukan1 = <Pemasukan>[];
  Map<String, double> data = {'Pemasukan': 0, 'Pengeluaran': 0};
  Map<String, double> dataPemasukan = {};
  Map<String, double> dataPengeluaran = {};
  final months = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'Mei': 5,
    'Jun': 6,
    'Jul': 7,
    'Agt': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Des': 12
  };
  final years = {
    '2015': 2015,
    '2016': 2016,
    '2017': 2017,
    '2018': 2018,
    '2019': 2019,
    '2020': 2020,
    '2021': 2021,
    '2022': 2022,
    '2023': 2023
  };
  List<Color> colorList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.brown,
    Colors.black,
    Colors.grey
  ];
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() {
    listPemasukan1.clear();
    listPengeluaran1.clear();
    for (Pemasukan p in listPemasukan) {
      print(year);
      if (p.tanggal.month == month && p.tanggal.year == year) {
        listPemasukan1.add(p);
      }
    }
    for (Pengeluaran p in listPengeluaran) {
      if (p.tanggal.month == month && p.tanggal.year == year) {
        listPengeluaran1.add(p);
      }
    }
    if (listPemasukan1.length > 0 && listPengeluaran1.length > 0) {
      for (Pengeluaran p in listPengeluaran1) {
        jumlahPengeluaran += p.jumlah;
        if (dataPengeluaran[mapK1[p.kategori - 4]!.nama] != null) {
          dataPengeluaran.update(
              mapK1[p.kategori - 4]!.nama, (value) => value += p.jumlah);
        } else {
          dataPengeluaran[mapK1[p.kategori - 4]!.nama] = p.jumlah;
        }
      }
      for (Pemasukan p in listPemasukan1) {
        jumlahPemasukan += p.jumlah;
        if (dataPemasukan[mapK[p.kategori - 1]!.nama] != null) {
          dataPemasukan.update(
              mapK[p.kategori - 1]!.nama, (value) => value += p.jumlah);
        } else {
          dataPemasukan[mapK[p.kategori - 1]!.nama] = p.jumlah;
        }
      }
      data.update('Pemasukan', (value) => jumlahPemasukan);
      data.update('Pengeluaran', (value) => jumlahPengeluaran);
    } else {
      print("list kosong");
      data.update('Pemasukan', (value) => 0);
      data.update('Pengeluaran', (value) => 0);
      dataPemasukan.clear();
      dataPengeluaran.clear();
      dataPemasukan['Kosong'] = 0;
      dataPengeluaran['Kosong'] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Statistik()))),
            title: Text('Statistik Bulanan')),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Transaksi Bulanan',
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Pilih Bulan',
                  textAlign: TextAlign.center,
                )),
            DropdownButton<int>(
              value: month,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              items: months.entries
                  .map<DropdownMenuItem<int>>(
                      (MapEntry<String, int> e) => DropdownMenuItem<int>(
                            value: e.value,
                            child: Text(e.key),
                          ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  month = newValue!;
                });
                addData();
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Pilih Tahun',
                  textAlign: TextAlign.center,
                )),
            DropdownButton<int>(
              value: year,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              items: years.entries
                  .map<DropdownMenuItem<int>>(
                      (MapEntry<String, int> e) => DropdownMenuItem<int>(
                            value: e.value,
                            child: Text(e.key),
                          ))
                  .toList(),
              onChanged: (int? newValue) {
                setState(() {
                  year = newValue!;
                });
                addData();
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text("Statistik Pengeluaran dan Pemasukan Bulanan"),
            Padding(
                padding: EdgeInsets.all(50),
                child: PieChart(
                  dataMap: data,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width /3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 50,
                  centerText: month.toString() + "/" + year.toString(),
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                )),
            Text("Statistik Kategori Pemasukan Bulanan"),
            Padding(
                padding: EdgeInsets.all(50),
                child: PieChart(
                  dataMap: dataPemasukan,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 50,
                  centerText: "Pemasukan",
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                )),
            Text("Statistik Pengeluaran Bulanan"),
            Padding(
                padding: EdgeInsets.all(50),
                child: PieChart(
                  dataMap: dataPengeluaran,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 50,
                  centerText: "Pengeluaran",
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                )),
          ])
        ]));
  }
}
