import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //backgroundColor: Colors.black,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final String title = "Abuja";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int temp;
  String description;
  String currently;
  int humidity;
  var windspeed;
  int pressure;
  String sunrise;
  String sunset;

  Future getWeather() async {
    http.Response res = await http.get(
      "http://api.openweathermap.org/data/2.5/weather?q=abuja&appid=&units=metric",
    );
    Map<String, dynamic> result = jsonDecode(res.body);
    this.temp = (await result['main']['temp']).round(); // in celsius
    this.description = (await result['weather'][0]['description']);
    this.currently = await result['weather'][0]['main'];
    this.humidity = await result['main']['humidity']; // in percent
    this.windspeed = await result['wind']['speed']; // in meter/sec
    this.pressure = await result['main']['pressure']; // in hPa
    DateTime a = DateTime.fromMillisecondsSinceEpoch(
        await result['sys']['sunrise'] * 1000);
    DateTime b = DateTime.fromMillisecondsSinceEpoch(
        await result['sys']['sunset'] * 1000);
    this.sunrise = DateFormat('h:mma').format(a).toLowerCase();
    this.sunset = DateFormat('h:mma').format(b).toLowerCase();

    setState(() {});
    print(res.body);
    print('$currently, $temp, $pressure');
  }

  final tsyle = GoogleFonts.sourceCodePro(
      textStyle: TextStyle(
    fontSize: 16,
  ));
  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Center(
              child: Text(
                "It's Sunny",
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: Colors.black38,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            )),
        title: Text(
          widget.title,
          style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.black45)),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 13, right: 8.0),
          child: IconButton(
            icon: Icon(
              EvaIcons.refresh,
              color: Colors.green,
            ),
            onPressed: () async {
              await this.getWeather();
            },
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: MediaQuery.of(context).size.height,
        child: Column(
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset(
                'assets/image/undraw_sunny_Orange.png',
                fit: BoxFit.fitWidth,
                color: Colors.grey.shade200,
                colorBlendMode: BlendMode.darken,
              ),
            ),
            SizedBox(
              height: 141,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "$temp\u00B0C",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(fontSize: 55),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0, top: 15),
                  child: Text(
                    DateFormat('h:mma').format(DateTime.now()),
                    style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 31,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.5, right: 8.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BoxedIcon(
                    WeatherIcons.windy,
                    size: 30,
                  ),
                  BoxedIcon(
                    WeatherIcons.sunrise,
                    size: 30,
                  ),
                  BoxedIcon(
                    WeatherIcons.sunset,
                    size: 30,
                  ),
                  BoxedIcon(
                    WeatherIcons.humidity,
                    size: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.5, right: 23.5, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${windspeed}m/s",
                    style: tsyle,
                  ),
                  Text(
                    "$sunrise",
                    style: tsyle,
                  ),
                  Text(
                    "$sunset",
                    style: tsyle,
                  ),
                  Text(
                    "$humidity%",
                    style: tsyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
