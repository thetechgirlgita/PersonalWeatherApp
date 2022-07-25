import 'package:flutter/material.dart';
import 'package:weatherapp/currentWeather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home:  CurrentWeatherPage(title: "Flutter"),
    );
  }
}