import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'map_page.dart';
import 'globals.dart' as globals;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Simple Login Demo',
        theme: new ThemeData(primarySwatch: Colors.blueGrey),
        home: new LoginPage(),
        routes: <String, WidgetBuilder>{
          '/map': (BuildContext context) => new MapPage(title: 'Map Page'),
        });
  }
}

class LoginPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Please Login"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _useridFilter,
              decoration: new InputDecoration(labelText: 'userid'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Login'),
            onPressed: _loginPressed,
          ),
        ],
      ),
    );
  }

  Future<void> _loginPressed() async {
    final res = await http.post('https://tokogeko.net/api/login',
        body: {'userid': _userid, 'password': _password});
    setState(() {
      globals.authToken = res.headers['authorization'];
//      print(globals.authToken);
      Navigator.of(context).pushNamed('/map');
    });
  }
}
