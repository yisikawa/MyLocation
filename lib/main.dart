import 'package:flutter/material.dart';
import 'login_page.dart';
import 'map_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Simple Login Demo',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        initialRoute: LoginPage.id,
        routes: <String, WidgetBuilder>{
          LoginPage.id: (BuildContext context) => LoginPage(),
          MapPage.id: (BuildContext context) => MapPage(title: 'Map Page'),
        });
  }
}
