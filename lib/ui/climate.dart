import 'dart:convert';
import 'package:flutter/material.dart';
import '../util/util.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;

class climate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new climatestate();
  }
}

class climatestate extends State<climate> {

 String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return new ChangeCity();
    }));

    if(result != null && result.containsKey('enter')) {
      _cityEntered = result['enter'];
      //print(result['enter'].toString());
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Climate"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            onPressed: () => {_goToNextScreen(context)},
            icon: new Icon(Icons.menu),
          ),
        ],
      ),
      body: new Stack(
        children: [
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              width: 550.0,
              height: 700.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0),
            child: new Text(
              "${_cityEntered == null ? util.defaultCity : _cityEntered}",
              style: cityStyle(),
            ),
          ),

          new Container(
              alignment: Alignment.center,
              child: new Image.asset('images/light_rain.png')),

          //Container which will have our weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 360.0, 0.0, 0.0),
            alignment: Alignment.center,
            child: updateTempWidget(_cityEntered),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=imperial';

    http.Response response = await http.get(
      Uri.parse(apiUrl),
    );
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        //where we get all of the json data, we setup widget.
        if (snapshot.hasData) {
          Map? content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    content!['main']['temp'].toString(),
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return new Container();
        }
      },
    );
  }
}


class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context,{
                      "enter" : _cityFieldController.text
                    });
                  },
                  child: new Text(
                    'Get Weather',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

//https://openweathermap.org/current using this website api.
//future builder use to build future object. it used to to give use future result.

//Passing a widget a context argument of type BuildContext allows the widget to figure out where it is located within the widget tree.
// Builder is used when a child widget wants to access something of a parent widget in the same build method.
// We solve this by giving the child widget a context through wrapping it in using the Builder class.

//A future of type Future<T> completes with a value of type T.
// For example, a future with type Future<String> produces a string value. If a future doesn’t produce a usable value, then the future’s type is Future<void>.

//AsyncSnapshot<List> class is Immutable or unchangable representation of the most recent interaction with an asynchronous computation.
//means if AsyncSnapshot<List> property have list type of data then, builder have AsyncSnapshot<List> and
//snapshot keyword take snapshort of value which is there is in future: property's value.

//future is a method or action gona happen in future and builder is used to wait for complete the action .
//async means are performing action of widget dynamically. means we can not do action in a serial wise.
// async always return future and future have different type like list, map, String.

// By declaring a non-nullable late variable, we promise that it will be non-null at runtime,
// and Dart helps us with some compile-time guarantees.

//Future<Map> creates a future object that holds Map values only
//
// future: is a property of FutureBuilder class where we write the instruction that we want/need to execute asychronously
//
// AsyncSnapshot class is used in the builder property of a StreamBuilder

