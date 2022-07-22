import 'package:flutter/material.dart';
import 'Colors.dart';
import 'weatherStyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'apiKeys.dart';
class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key, String? title}) : super(key: key);


  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late  Weather _weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundC,
        appBar: AppBar(
        backgroundColor: appbarC,
        centerTitle: true,
        title:  const Text("Weather Forecast",
        style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
    )),),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:  [
                Padding(
                  child: IconButton(
                    onPressed: (){
                      showSearch(
                        context: context,
                        delegate: ListOfCountries(),
                      );
                    },
                    icon:  const Icon(Icons.location_pin,
                      color: Colors.yellow,
                      size: 35,
                    ),
                  ),

                  padding: const EdgeInsets.only(top: 10),
                ),
                const Text("Delhi",
                    style: TextStyle(
                      fontSize: 25,
                      color:  Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                ),


           FutureBuilder(
            builder: (context, snapshot) {
              // ignore: unnecessary_null_comparison
              if (snapshot.hasData) {
               _weather =  snapshot.data as Weather;
                // ignore: unnecessary_null_comparison
                if (snapshot.hasError) {
                  return const Text("Error getting weather");
                } else {
                  return  weatherBox(_weather);
                }
              } else {
                return  const CircularProgressIndicator();
              }
            },
            future: getCurrentWeather(),
          ),
        ],),],),
    );
  }
}

Widget weatherBox(Weather _weather) {

  return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(10.0),
            child:
            Text("${_weather.temp}°C",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55,
              color: textC
              ),
            )
        ),
        Container(
            margin: const EdgeInsets.all(5.0),
            child: Text(_weather.description,
              style : TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textC
              ),
            )
        ),
        Container(
            margin: const EdgeInsets.all(5.0),
            child: Text("Feels:${_weather.feelsLike}°C",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                color: textC
            ),)
        ),
        Container(
            margin: const EdgeInsets.all(5.0),
            child: Text("H:${_weather.high}°C L:${_weather.low}°C",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                color: textC
            ),)
        ),
      ]

  );
}


Future getCurrentWeather() async {
  Weather weather;


  var response = await http.get(Uri.parse(apiURL));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Failed to load ');
  }

  return weather;
}
class ListOfCountries extends SearchDelegate {
// Demo list to show querying
  List<String> searchTerms = [
    "India",
    "Nepal",
    "Maldives",
    "USA",
    "Canada",
    "China",
    "Russia",
    "Srilanka",
    "IreLand",
    "Newzealand",
    "Japan",
    "Germany",
    "France",
    "Paris"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var country in searchTerms) {
      if (country.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(country);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}