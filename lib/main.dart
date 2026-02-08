import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() => runApp(MaterialApp(home: WeatherApp(), debugShowCheckedModeBanner: false));

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey = "93f955b07bafb5818683f8599276a242"; 
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  String cityName = "Loading...";

  Future getWeather() async {
    // 1. Get Location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    // 2. Fetch Data
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey"));
    
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.cityName = results['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Currently in $cityName", style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600)),
                Text(temp != null ? temp.toString() + "\u00B0C" : "Loading", style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.w600)),
                Text(currently != null ? currently.toString() : "Loading", style: TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  ListTile(leading: Icon(Icons.thermostat), title: Text("Temperature"), trailing: Text(temp != null ? temp.toString() + "\u00B0C" : "N/A")),
                  ListTile(leading: Icon(Icons.cloud), title: Text("Weather"), trailing: Text(description != null ? description.toString() : "N/A")),
                  ListTile(leading: Icon(Icons.wb_sunny), title: Text("Humidity"), trailing: Text(humidity != null ? humidity.toString() + "%" : "N/A")),
                  ListTile(leading: Icon(Icons.air), title: Text("Wind Speed"), trailing: Text(windSpeed != null ? windSpeed.toString() : "N/A")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}