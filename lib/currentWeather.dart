import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Colors.dart';
import 'weatherStyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'apiKeys.dart';

const location = "Noida, 137";

Image IconGet(Weather _weather) {
  Image iconC;
  iconC = Image.asset('lib/images/sunny.png');
  if (_weather.description == 'light rain') {
    iconC = Image.asset('lib/images/weather-app.png');
  }
  ;
  if (_weather.description == 'broken clouds') {
    iconC = Image.asset('lib/images/cloud.png');
  }
  if (_weather.description == 'clear sky') {
    iconC = Image.asset('lib/images/sunny.png');
  }
  if (_weather.description == 'thunderstorm') {
    iconC = Image.asset('lib/images/storm.png');
  }

  return iconC;
}

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key, String? title}) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late Weather _weather;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.pinkAccent])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: const Text("Weather Forecast",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 40,
                          color: textC,
                        ),
                        const Text(location,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        builder: (context, snapshot) {
// ignore: unnecessary_null_comparison
                          if (snapshot.hasData) {
                            _weather = snapshot.data as Weather;
// ignore: unnecessary_null_comparison
                            if (snapshot.hasError) {
                              return const Text("Error getting weather");
                            } else {
                              return weatherBox(_weather);
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                        future: getCurrentWeather(),
                      ),
                    ]),
              ],
            )));
  }
}

Widget weatherBox(Weather _weather) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      height: 180,
      width: 340,
      child: Row(children: [
        Column(children: [
          Container(
            width: 100,
            height: 130,
            child: IconGet(
              _weather,
            ),
          ),
          Container(
              margin: const EdgeInsets.all(5.0),
              child: Text(
                _weather.description,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              )),
        ]),
        const SizedBox(
          height: 30,
          width: 15,
        ),
        Text(
          "${_weather.temp}°C",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45,
              color: Colors.yellowAccent),
        ),
      ]),
    ),
// Container Style nad temperature body.
    //---------------------------------------------------------------------------------------------------------

    Container(
        margin: const EdgeInsets.all(50),
        child: Text(
          "Feels : ${_weather.feelsLike}°C",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.yellowAccent),
        )),

    Container(
      margin: const EdgeInsets.all(5.0),
      child: Row(children: [
        const Icon(
          Icons.arrow_upward_sharp,
          color: Colors.white,
        ),
        Text("   Max :  ${_weather.high}°C ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.yellowAccent)),
      ]),
    ),

    Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          Text(
            "  Mini :  ${_weather.low}°C    ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.yellowAccent),
          ),
        ],
      ),
    ),
    /*Padding(
        padding: EdgeInsets.only(top: 30),
        child: Container(
            height: 40,
            width: 180,
            color: Colors.transparent,
            alignment: Alignment.center,

              child: Row(children:const [
                Icon(
                  Icons.woman,
                  color: Colors.white,
                ),
                Text("   ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,)
              ]),
            ))*/
  ]);
}

Future getCurrentWeather() async {
  Weather weather;

  var response = await http.get(Uri.parse(apiURL));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load ');
  }

  return weather;
}
