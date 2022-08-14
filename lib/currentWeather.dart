import 'package:flutter/material.dart';
import 'Colors.dart';
//import 'lib/SearchBar.dart';
import 'lib/SearchBar.dart';
import 'weatherStyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'apiKeys.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const location = "Noida,137";

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key, String? title}) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late Weather _weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
      appBar: AppBar(
        backgroundColor: appbarC,
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
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(location,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ]),
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
      ),
    );
  }
}

Widget weatherBox(Weather _weather) {
  return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    Column(children: [
      const Icon(
        Icons.wb_sunny_rounded,
        color: Colors.amber,
        size: 50,
      ),
      const SizedBox(
        height: 30,
        width: 30,
      ),
      Text(
        "${_weather.temp}°C",
        textAlign: TextAlign.center,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: textC),
      ),
    ]),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(
          _weather.description,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: textC),
        )),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(
          "Feels:${_weather.feelsLike}°C",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: textC),
        )),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(
          "H:${_weather.high}°C L:${_weather.low}°C",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: textC),
        )),
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
