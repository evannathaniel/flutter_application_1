import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/ui/Transaksi/transaksi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'class/kategori.dart';
import 'class/loan.dart';
import 'class/pemasukan.dart';
import 'class/pengeluaran.dart';
import 'ui/Fitur/fitur.dart';
import 'ui/Statistik/statistik.dart';
import 'ui/Transaksi/transaksi.dart';
import 'ui/login.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;
String active_user = "";
String id = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_name = prefs.getString("user_name") ?? '';
  id = prefs.getString("user_id") ?? '';
  return user_name;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('@drawable/app_icon'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(
        MaterialApp(
          title: 'Financer',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: MyHomePage(),
        ),
      );
    }
  });
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financer',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    this.notificationAppLaunchDetails,
  }) : super(key: key);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double pengeluaran = 0;
  double pemasukan = 0;
  String bool1 = 'False';
  List<bool> isSelected = [];
  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/pendapatan.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData1() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/TA/pengeluaran.php"),
        body: {'id': id});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData2() async {
    final response = await http
        .post(Uri.parse("https://ubaya.fun/flutter/160718008/TA/kategori.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData3() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/loan.php"),
        body: {'cari': ""});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> _zonedScheduleNotification(
      DateTime d, String nama, int id, int b) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Pengingat Tagihan',
        'Deadline tagihan ' + nama + ' tersisa ' + b.toString() + ' hari',
        tz.TZDateTime.local(d.year, d.month, d.day - b, 9),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    print(b);
  }

  Future<void> _zonedScheduleNotification1(
      DateTime d, String nama, int id) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Pengingat Tagihan',
        'Hari ini adalah tanggal jatuh tempo untuk tagihan',
        tz.TZDateTime.local(d.year, d.month, d.day),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  bacaData3() {
    listLoans.clear();
    Future<String> data = fetchData3();
    data.then((value) async {
      Map json = jsonDecode(value);
      for (var g in json['data']) {
        Loan gs = Loan.fromJson(g);
        listLoans.add(gs);
      }
      setState(() {});
    });
  }

  bacaData1() {
    listKategori.clear();
    listKategori1.clear();
    Future<String> data = fetchData2();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Kategori k = Kategori.fromJson(p);
        if (k.id <= 3)
          listKategori.add(k);
        else
          listKategori1.add(k);
      }
      setState(() {});
    });
  }

  bacaData() {
    listPemasukan.clear();
    listPengeluaran.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Pemasukan pm = Pemasukan.fromJson(p);
        listPemasukan.add(pm);
      }
      setState(() {});
    });
    Future<String> data1 = fetchData1();
    data1.then((value) {
      Map json = jsonDecode(value);
      for (var p in json['data']) {
        Pengeluaran pm = Pengeluaran.fromJson(p);
        listPengeluaran.add(pm);
      }
      setState(() {});
    });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                if (receivedNotification.id > 0) {
                  await flutterLocalNotificationsPlugin
                      .cancel(receivedNotification.id);
                }
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Transaksi(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_name");
    main();
  }

  Widget showTransaction() {
    final currencyFormatter = NumberFormat.currency(locale: 'ID');
    pemasukan = 0;
    pengeluaran = 0;
    if (listPemasukan.length > 0) {
      for (Pemasukan p in listPemasukan) {
        if (DateFormat('yyyy-MM-dd').format(p.tanggal) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          pemasukan += p.jumlah;
        }
      }
    }
    if (listPengeluaran.length > 0) {
      for (Pengeluaran p in listPengeluaran) {
        if (DateFormat('yyyy-MM-dd').format(p.tanggal) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          pengeluaran += p.jumlah;
        }
      }
    }
    return new Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.arrow_upward, size: 30),
          title: Text(
            'Pemasukan',
            style: TextStyle(fontSize: 20, color: Colors.blue),
            textAlign: TextAlign.justify,
          ),
          subtitle: Text(currencyFormatter.format(pemasukan)),
        ),
        ListTile(
          leading: Icon(Icons.arrow_downward, size: 30),
          title: Text('Pengeluaran',
              style: TextStyle(fontSize: 20, color: Colors.red),
              textAlign: TextAlign.justify),
          subtitle: Text(currencyFormatter.format(pengeluaran)),
        ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    bacaData1();
    bacaData();
    bacaData3();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    print(listKategori.length);
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Hello " + active_user),
            accountEmail: Text("Welcome To Financer"),
          ),
          ListTile(
            title: new Text("Log Out"),
            leading: new Icon(Icons.logout),
            onTap: doLogout,
          ),
          ListTile(
              title: new Text("Transaksi "),
              leading: new Icon(Icons.money),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transaksi()));
              }),
          ListTile(
              title: new Text("Kelola"),
              leading: new Icon(Icons.money),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Fitur()));
              }),
          ListTile(
              title: new Text("Statistik "),
              leading: new Icon(Icons.money),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Statistik()));
              }),
        ],
      ),
    );
  }

  Future<void> createnotif() async {
    for (Loan l in listLoans) {
      if (l.tanggal.isAfter(DateTime.now())) {
        int diff = l.tanggal.difference(DateTime.now()).inDays;
        if (diff >= 7) {
          await _zonedScheduleNotification(l.tanggal, l.nama, l.id, 7);
          print('a');
        } else if (diff > 0) {
          await _zonedScheduleNotification(l.tanggal, l.nama, l.id, diff);
        }
      }
      await _zonedScheduleNotification1(
          DateTime(DateTime.now().year, DateTime.now().month, l.jatuhTempo),
          l.nama,
          l.id + 1000);
    }
  }

  Future<void> _showNotification1() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Pengaturan Notifikasi',
        'Notifikasi Nyala', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotification2() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Pengaturan Notifikasi', 'Notifikasi Mati', platformChannelSpecifics,
        payload: 'item x');
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 21);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleDailyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Daily Reminder',
        "Jangan lupa mencatat pengeluaran hari ini",
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Home'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Transaksi Hari ini ',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              )),
          Divider(height: 50),
          showTransaction(),
          Divider(
            height: 50,
          ),
          PaddedElevatedButton(
            buttonText: 'Turn On Notification',
            onPressed: () async {
              await _cancelAllNotifications();
              await _showNotification1();
              await _scheduleDailyNotification();
              await createnotif();
            },
          ),
          PaddedElevatedButton(
            buttonText: 'Turn Off Notification',
            onPressed: () async {
              await _cancelAllNotifications();
              await _showNotification2();
            },
          ),
        ]),
      ),
      drawer: myDrawer(),
    );
  }
}
