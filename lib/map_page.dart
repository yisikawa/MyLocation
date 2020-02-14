import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;

class MapPage extends StatefulWidget {
// コンストラクト
  MapPage({Key key, this.title}) : super(key: key);

// 定数定義
  final String title;

// アロー関数を用いて、Stateを呼ぶ
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<dynamic> _data;

  @override
  void initState() {
    super.initState();
    _getAuth();
  }

  Future<void> _getAuth() async {
    final res = await http.get(
      globals.targetUrl + 'api/auth',
      headers: {HttpHeaders.authorizationHeader: globals.authToken},
    );
    final jsonList = json.decode(res.body);

    jsonList.forEach((value) {
      Map _tmp = value;
      _data.add(_tmp['user_id']);
    });
  }

  Widget buildListView() {
    _getAuth();
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _data.length,
        /* Divider を挟む */
        itemBuilder: (context, i) {
          final index = i;
          return ListTile(
            title: Text(_data[index]),
          );
        });
  }

  DateTime selectedDate = DateTime.now();
  String selectDate = '';

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019, 4),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        //ここで選択された値を変数なり、コントローラーに代入する
        globals.targetDate = DateFormat('yyyyMMdd').format(selectedDate);
        print('select date = ' + globals.targetDate);
      });
    }
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: _mapView(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Map"),
//      centerTitle: true,
//      leading:
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.account_box), onPressed: () => buildListView()),
        IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context)),
        IconButton(icon: Icon(Icons.directions_walk), onPressed: null),
        IconButton(icon: Icon(Icons.watch_later), onPressed: null),
        IconButton(
          icon: Icon(Icons.location_on),
          onPressed: null,
        ),
      ],
    );
  }

  Widget _mapView(BuildContext context) {
    return new GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        // 最初のカメラ位置
        target: LatLng(35.000081, 137.004055),
        zoom: 17.0,
      ),
    );
  }
}
