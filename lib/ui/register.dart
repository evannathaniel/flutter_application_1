import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'login': (context) => Login()},
    );
  }
}

class _RegisterState extends State<Register> {
  // ignore: non_constant_identifier_names
  TextEditingController _user_id_cont = TextEditingController();
  TextEditingController _user_name_cont = TextEditingController();
  TextEditingController _user_pass_cont = TextEditingController();
  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/newuser.php"),
        body: {
          'user_id': _user_id_cont.text,
          'user_name': _user_name_cont.text,
          'user_password': _user_pass_cont.text,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", _user_id_cont.text);
        prefs.setString("user_name", _user_name_cont.text);
        main();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Pendaftaran sukses')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_id_cont.text = "";
    _user_name_cont.text = "";
    _user_pass_cont.text = "";

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Akun Baru'),
        ),
        body: Container(
          height: 420,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 20)]),
          child: ListView(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _user_id_cont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter User Name'),
                onSubmitted: (v) {
                  _user_id_cont.text = v;
                },
              ),
            ),
           
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _user_pass_cont,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
                onSubmitted: (v) {
                  _user_pass_cont.text = v;
                },
              ),
            ),
             Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _user_name_cont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name'),
                onSubmitted: (v) {
                  _user_name_cont.text = v;
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Daftar',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text("Sudah Punya Akun? Login Disini!"),
              ),
            ),
          ]),
        ));
  }
}
