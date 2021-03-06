import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:io';
import 'globals.dart' as globals;

class MapPage extends StatefulWidget {
  static const id = 'map_page';
// コンストラクト
  MapPage({Key key, this.title}) : super(key: key);

// 定数定義
  final String title;

// アロー関数を用いて、Stateを呼ぶ
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _data = "";

  Future<void> _getAuth() async {
    final res = await http.get(
      'https://tokogeko.net/api/auth',
      headers: {HttpHeaders.authorizationHeader: globals.authToken},
    );
    setState(() {
      _data = res.body;
      print(_data);
    });
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
      title: new Text("Map Page"),
      centerTitle: true,
    );
  }

  Widget _mapView(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(35.000081, 137.004055),
        zoom: 17.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoieWlzaWthd2EiLCJhIjoiY2s2YndmdXFuMGZ1bDNsb3ZnMXBsbnI3eSJ9.gftC8NPsB9xNWIVEdWnTvw',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 20.0,
              height: 20.0,
              point: new LatLng(35.000081, 137.004055),
              builder: (ctx) => new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
