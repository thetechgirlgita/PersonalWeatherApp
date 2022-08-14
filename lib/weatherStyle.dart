import 'dart:ui';

import 'package:flutter/material.dart';

class Weather {
  final int temp;
  final int feelsLike;
  final int low;
  final int high;
  final String description;
  final String weatherIcon;

  Weather( {
    required this.weatherIcon,
    required this.temp,
    required this.feelsLike,
    required this.low,
    required this.high,
    required this.description});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(

      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      weatherIcon: json['weather']['icon'],

    );
  }
}