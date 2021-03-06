import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log/map_page.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class LoginPage extends StatefulWidget {
  static const id = 'login_page';
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _useridFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _userid = "";
  String _password = "";

  _LoginPageState() {
    _useridFilter.addListener(_useridListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _useridListen() {
    if (_useridFilter.text.isEmpty) {
      _userid = "";
    } else {
      _userid = _useridFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  Future<void> _loginPressed() async {
    final res = await http.post(globals.targetUrl + 'api/login',
        body: {'userid': _userid, 'password': _password});
    globals.authToken = res.headers['authorization'];
    setState(() {
      if (globals.authToken != null) {
        print(globals.authToken);
        Navigator.of(context).pushNamed(MapPage.id);
      } else {
        print('can not login!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログインしてください"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _useridFilter,
              decoration: InputDecoration(
                  labelText: 'ユーザーID',
                  hintText: 'enter user ID',
                  icon: Icon(
                    Icons.account_circle,
                    size: 40.0,
                  )),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordFilter,
              decoration: InputDecoration(
                  labelText: 'パスワード',
                  hintText: 'enter password',
                  icon: Icon(
                    Icons.security,
                    size: 40.0,
                  )),
              obscureText: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                'ログイン',
              ),
              onPressed: _loginPressed,
            ),
          ],
        ),
      ),
    );
  }
}
