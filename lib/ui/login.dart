import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  TextEditingController _id_cont = TextEditingController();
  TextEditingController _pass_cont = TextEditingController();
  late String error_login;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _id_cont.text = "";
    _pass_cont.text = "";
  }

  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718008/login.php"),
        body: {'user_id': _id_cont.text, 'user_password': _pass_cont.text});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", _id_cont.text);
        prefs.setString("user_name", json['user_name']);
        main();
      } else {
        setState(() {
          error_login = "User id atau password error";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          height: 350,
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
                controller: _id_cont,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User name',
                    hintText: 'Enter User name'),
                onSubmitted: (v) {
                  _id_cont.text = v;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _pass_cont,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
                onSubmitted: (v) {
                  _pass_cont.text = v;
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
                      doLogin();
                    },
                    child: Text(
                      'Login',
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
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text("Buat Akun Baru Disini!"),
              ),
            ),
          ]),
        ));
  }
}
